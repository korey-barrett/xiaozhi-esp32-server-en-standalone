# How to get device information using MCP methods

This tutorial will guide you on how to use MCP methods to get device information.

Step 1: Customize your `agent-base-prompt.txt` file

Copy the contents of the `agent-base-prompt.txt` file in the xiaozhi-server directory to your `data` directory, and rename it to `.agent-base-prompt.txt`.

Step 2: Modify the `data/.agent-base-prompt.txt` file, find the `<context>` tag, and add the following code content inside the tag:
```
- **Device ID:** {{device_id}}
```

After adding it, the `<context>` tag content of your `data/.agent-base-prompt.txt` file should roughly look like this:
```
<context>
【Important! The following information is provided in real time and can be used directly without querying via a tool:】
- **Device ID:** {{device_id}}
- **Current time:** {{current_time}}
- **Today's date:** {{today_date}} ({{today_weekday}})
- **Today's lunar date:** {{lunar_date}}
- **User's city:** {{local_address}}
- **Local weather for the next 7 days:** {{weather_info}}
</context>
```

Step 3: Modify the `data/.config.yaml` file, find the `agent-base-prompt` configuration. The content before modification is as follows:
```
prompt_template: agent-base-prompt.txt
```
Change it to
```
prompt_template: data/.agent-base-prompt.txt
```

Step 4: Restart your xiaozhi-server service.

Step 5: In your mcp method, add a parameter named `device_id`, of type `string`, with the description `Device ID`.

Step 6: Wake up Xiaozhi again, let it call the mcp method, and check whether your mcp method can get the `Device ID`.
