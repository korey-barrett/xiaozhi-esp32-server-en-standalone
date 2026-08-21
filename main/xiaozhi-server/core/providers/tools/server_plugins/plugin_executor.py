"""Server-side plugin tool executor"""

import asyncio
from typing import Dict, Any, TYPE_CHECKING

if TYPE_CHECKING:
    from core.connection import ConnectionHandler
from ..base import ToolType, ToolDefinition, ToolExecutor
from plugins_func.register import all_function_registry, module_func_map, Action, ActionResponse


class ServerPluginExecutor(ToolExecutor):
    """Server-side plugin tool executor"""

    def __init__(self, conn: "ConnectionHandler"):
        self.conn = conn
        self.config = conn.config

    async def execute(
        self, conn: "ConnectionHandler", tool_name: str, arguments: Dict[str, Any]
    ) -> ActionResponse:
        """Execute a server-side plugin tool"""
        func_item = all_function_registry.get(tool_name)
        if not func_item:
            return ActionResponse(
                action=Action.NOTFOUND, response=f"Plugin function {tool_name} does not exist"
            )

        try:
            # Determine how to call based on the tool type
            if hasattr(func_item, "type"):
                func_type = func_item.type
                if func_type.code in [4, 5]:  # SYSTEM_CTL, IOT_CTL (requires conn parameter)
                    result = func_item.func(conn, **arguments)
                elif func_type.code == 2:  # WAIT
                    result = func_item.func(**arguments)
                elif func_type.code == 3:  # CHANGE_SYS_PROMPT
                    result = func_item.func(conn, **arguments)
                else:
                    result = func_item.func(**arguments)
            else:
                # By default, do not pass the conn parameter
                result = func_item.func(**arguments)

            # Support async def tool functions
            if asyncio.iscoroutine(result):
                result = await result

            return result

        except Exception as e:
            return ActionResponse(
                action=Action.ERROR,
                response=str(e),
            )

    def _expand_plugin_names(self, config_functions):
        """Expand module-level plugin names into concrete function names.

        A single function file may register multiple @register_function entries.
        If the config uses a module name (file name), expand it into the concrete function name list.
        """
        if not isinstance(config_functions, list):
            try:
                config_functions = list(config_functions)
            except TypeError:
                return []

        expanded = []
        for name in config_functions:
            if name in module_func_map:
                # Module name, expand into all registered function names under that module
                expanded.extend(module_func_map[name])
            elif name in all_function_registry:
                # Exact function name match, keep as-is
                expanded.append(name)
            else:
                # Unknown name, keep the original value (may be an MCP or other tool)
                expanded.append(name)
        return expanded

    def _get_plugin_description(self, func_name):
        """Get the plugin function description, preferring exact function name match, then module name match."""
        plugins = self.config.get("plugins", {})
        # Exact function name match
        if func_name in plugins:
            return plugins[func_name].get("description", "")
        # Look up the module name in reverse via module_func_map
        for module_name, func_names in module_func_map.items():
            if func_name in func_names and module_name in plugins:
                return plugins[module_name].get("description", "")
        return ""

    def get_tools(self) -> Dict[str, ToolDefinition]:
        """Get all registered server-side plugin tools"""
        tools = {}

        # Get the necessary functions
        necessary_functions = ["handle_exit_intent", "get_lunar"]

        # Get the functions from the config
        config_functions = self.config["Intent"][
            self.config["selected_module"]["Intent"]
        ].get("functions", [])

        # Expand module-level plugin names into concrete function names (fallback mechanism)
        config_functions = self._expand_plugin_names(config_functions)

        # Merge all required functions
        all_required_functions = list(set(necessary_functions + config_functions))

        for func_name in all_required_functions:
            func_item = all_function_registry.get(func_name)
            if func_item:
                # Get the description from the function registry (supports two-level lookup by module name and function name)
                fun_description = self._get_plugin_description(func_name)
                if fun_description is not None and len(fun_description) > 0:
                    if "function" in func_item.description and isinstance(
                        func_item.description["function"], dict
                    ):
                        func_item.description["function"][
                            "description"
                        ] = fun_description

                # News plugin: update the news source parameter description from the config
                if func_name == "get_news_from_newsnow":
                    self._init_news_source_description(func_item, func_name)

                tools[func_name] = ToolDefinition(
                    name=func_name,
                    description=func_item.description,
                    tool_type=ToolType.SERVER_PLUGIN,
                )

        return tools

    def has_tool(self, tool_name: str) -> bool:
        """Check whether a specific server-side plugin tool exists"""
        return tool_name in all_function_registry

    def _init_news_source_description(self, func_item, func_name):
        """Initialize the news tool's parameter description from the connection config"""
        news_sources = (
            self.config.get("plugins", {})
            .get(func_name, {})
            .get("news_sources", "")
        )
        if not news_sources:
            news_sources = "Hacker News;Product Hunt;Github"
        sources_str = news_sources.replace(";", "、")
        try:
            func_item.description["function"]["parameters"]["properties"]["source"][
                "description"
            ] = f"The standard Chinese name of the news source, e.g. {sources_str}. Optional; if not provided, the default news source is used"
        except (KeyError, TypeError):
            pass
