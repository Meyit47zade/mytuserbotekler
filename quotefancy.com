# Ultroid - UserBot
# Copyright (C) 2020 TeamUltroid
#
# This file is a part of < https://github.com/TeamUltroid/Ultroid/ >
# PLease read the GNU Affero General Public License in
# <https://www.github.com/TeamUltroid/Ultroid/blob/main/LICENSE/>.


"""
✘ Commands Available

• `{i}qfancy`
    Gets random quotes from QuoteFancy.com.
"""

from . import *
from quotefancy import get_quote
from telethon.errors import ChatSendMediaForbiddenError


@ultroid_cmd(pattern="qfancy$")
async def quotefancy(e):
    mes = await eor(e, "`Processing...`")
    img = get_quote("img", download=True)
    try:
        await ultroid_bot.send_file(e.chat_id, img)
        os.remove(img)
    except ChatSendMediaForbiddenError:
        quote = get_quote("text")
        await eor(e,f"`{quote}`")
    except Exception as e:
        await eor(e, f"**ERROR** - {str(e)}")


HELP.update({f"{__name__.split('.')[1]}": f"{__doc__.format(i=HNDLR)}"})
