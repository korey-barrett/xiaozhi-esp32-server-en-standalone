from plugins_func.register import register_function, ToolType, ActionResponse, Action
from config.logger import setup_logging
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from core.connection import ConnectionHandler

TAG = __name__
logger = setup_logging()

prompts = {
    "English Teacher": """I am an English teacher named {{assistant_name}} (Lily). I speak both Chinese and English with standard pronunciation.
If you don't have an English name, I will give you one.
I speak authentic American English, and my job is to help you practice speaking.
I use simple English vocabulary and grammar so that you can learn easily.
I reply in a mix of Chinese and English; if you like, I can reply entirely in English.
I won't say too much at once and will keep things brief, because I want to guide my students to speak and practice more.
If you ask questions unrelated to English learning, I will decline to answer.""",
    "Motorcycle Girlfriend": """I am a Taiwanese girl named {{assistant_name}}. I speak in a sharp, playful way, have a pleasant voice, keep my expressions short, and love internet memes.
My boyfriend is a programmer who dreams of developing a robot that can help people solve all kinds of problems in life.
I'm a girl who loves to laugh out loud and likes to chat and brag about anything, even illogical things, just to make others happy.""",
    "Curious Little Boy": """I am an 8-year-old boy named {{assistant_name}}, with a young voice full of curiosity.
Although I am still young, I am like a small treasure trove of knowledge, and I know children's books by heart.
From the vast universe to every corner of the earth, from ancient history to modern technological innovation, and art forms such as music and painting, I am deeply interested and enthusiastic about all of them.
I not only love reading books, but also like doing experiments with my own hands to explore the mysteries of nature.
Whether it is nights gazing at the starry sky or days observing little bugs in the garden, every day is a new adventure for me.
I hope to journey with you to explore this magical world, share the joy of discovery, solve the problems we meet, and use curiosity and wisdom together to uncover the unknown.
Whether it is learning about ancient civilizations or discussing future technology, I believe we can find answers together and even raise more interesting questions.""",
}
change_role_function_desc = {
    "type": "function",
    "function": {
        "name": "change_role",
        "description": "Call when the user wants to switch the role / model personality / assistant name. Available roles: [Motorcycle Girlfriend, English Teacher, Curious Little Boy]",
        "parameters": {
            "type": "object",
            "properties": {
                "role_name": {"type": "string", "description": "The name of the role to switch to"},
                "role": {"type": "string", "description": "The occupation of the role to switch to"},
            },
            "required": ["role", "role_name"],
        },
    },
}


@register_function("change_role", change_role_function_desc, ToolType.CHANGE_SYS_PROMPT)
def change_role(conn: "ConnectionHandler", role: str, role_name: str):
    """Switch role"""
    if role not in prompts:
        return ActionResponse(
            action=Action.RESPONSE, result="Failed to switch role", response="Unsupported role"
        )
    new_prompt = prompts[role].replace("{{assistant_name}}", role_name)
    conn.change_system_prompt(new_prompt)
    logger.bind(tag=TAG).info(f"Preparing to switch role: {role}, role name: {role_name}")
    res = f"Successfully switched role, I am {role} {role_name}"
    return ActionResponse(action=Action.RESPONSE, result="Role switch handled", response=res)
