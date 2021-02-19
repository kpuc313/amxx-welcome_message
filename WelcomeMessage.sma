/*****************************************************************
*                            MADE BY
*
*   K   K   RRRRR    U     U     CCCCC    3333333      1   3333333
*   K  K    R    R   U     U    C     C         3     11         3
*   K K     R    R   U     U    C               3    1 1         3
*   KK      RRRRR    U     U    C           33333   1  1     33333
*   K K     R        U     U    C               3      1         3
*   K  K    R        U     U    C     C         3      1         3
*   K   K   R         UUUUU U    CCCCC    3333333      1   3333333
*
******************************************************************
*                       AMX MOD X Script                         *
*     You can modify the code, but DO NOT modify the author!     *
******************************************************************
*
* Description:
* ============
* This plugin shows welcome message when player is connected to the server.
*
*****************************************************************/

#include <amxmodx>

new TAG[] = "WM"

new g_SayText
new wm_enable, wm_time, wm_sound, wm_site

public plugin_init() {
	register_plugin("Welcome Message", "0.1", "kpuc313");
	register_dictionary("wm.txt")
	
	wm_enable = register_cvar("amx_wm_enable","1")
	wm_time = register_cvar("amx_wm_time","7.0")
	wm_sound = register_cvar("amx_wm_sound","1")
	wm_site = register_cvar("amx_wm_site","www.YourSite.com")
	
	g_SayText = get_user_msgid("SayText")
}

public plugin_precache() {
	precache_sound("buttons/bell1.wav")
}

public client_putinserver(id) {
    if(get_pcvar_num(wm_enable)) {
	set_task(get_pcvar_float(wm_time), "wm", id)
    }
}


public wm(id) {
	if(get_pcvar_num(wm_enable)) {
		new name[33], ip[32], map[32], hostname[64], site[200]
		get_user_name(id, name, 32)
		get_user_ip(id, ip, 16, 1)
		get_mapname(map, 31)
		get_cvar_string("hostname", hostname, 63)
		get_pcvar_string(wm_site, site, charsmax(site))
		
		client_printc(id, "/g[%s]/y %L", TAG, LANG_PLAYER, "WELCOME_MESSAGE", name, site)
		client_printc(id, "/g[%s]/y %L", TAG, LANG_PLAYER, "WELCOME_MESSAGE_IP", ip)
		client_printc(id, "/g[%s]/y %L", TAG, LANG_PLAYER, "WELCOME_MESSAGE_HOST", hostname, map)
		
		if(get_pcvar_num(wm_sound)) {
			client_cmd(id,"spk buttons/bell1")
		}
	}
} 

stock client_printc(const id, const string[], {Float, Sql, Resul,_}:...) {
	
	new msg[191], players[32], count = 1;
	vformat(msg, sizeof msg - 1, string, 3);
	
	replace_all(msg,190,"/g","^4");
	replace_all(msg,190,"/y","^1");
	replace_all(msg,190,"/t","^3");
	
	if(id)
		players[0] = id;
	else
		get_players(players,count,"ch");
	
	for (new i = 0 ; i < count ; i++)
	{
		if (is_user_connected(players[i]))
		{
			message_begin(MSG_ONE_UNRELIABLE, g_SayText,_, players[i]);
			write_byte(players[i]);
			write_string(msg);
			message_end();
		}		
	}
}
