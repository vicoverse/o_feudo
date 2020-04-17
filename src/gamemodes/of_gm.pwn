/*
 *	@name				O FEUDO - GameMode Principal
 *	@version			0.0alpha
 *	@author				Vico
 *	@description		Gamemode 4fun para o SA:MP 0.3DL.
 *
 */
 
/* BIBLIOTECAS */
#include "../include/of_db.inc"				// Biblioteca de banco de dados (que herda também a principal do projeto)

/* CONSTANTES */
// dcmd
#define dcmd(%1,%2,%3) if (!strcmp((%3)[1], #%1, true, (%2)) && ((((%3)[(%2) + 1] == '\0') && (dcmd_%1(playerid, ""))) || (((%3)[(%2) + 1] == ' ') && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1
// Frequência que o timer de sincronização de dados vai salvar os dados dos players normalmente (a cada minuto)
#define SYNC_FREQUENCY_MS 60000

/* DIÁLOGOS */
// Enum com as IDS dos diálogos
enum
{
    DIALOGO_REGISTRO,
    DIALOGO_LOGIN
}

/* VARIÁVEIS */
new DB:db_handle;					// Variável que armazena a conexão atual com o banco de dados
new db_filename[] = "data.db";		// Nome do banco de dados principal (ALTERAR SE FOR NECESSÁRIO)
new sync_timer_id;					// Armazena o ID do timer da sincronização de dados

/* FUNÇÃO PRINCIPAL DO GM */
main()
{
	print("[info] [main]: Servidor operacional!\n");
}

/* CALLBACKS */
/* OnGameModeInit */
public OnGameModeInit()
{
	// Ajusta as informações do servidor
	SetGameModeText("O Feudo v0.0alpha");
	
	// Conecta com o banco de dados
	conectar_bancodedados(db_filename, db_handle);
	
	// Ativa o timer de sincronização de dados
	sync_timer_id = SetTimerEx("sync_players", SYNC_FREQUENCY_MS, true, "i", DB:db_handle);
	
	// TEMPORARIO
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	return 1;
}

public OnGameModeExit()
{
	// Encerra o timer de sincronização
	KillTimer(sync_timer_id);
	// Desconecta com o banco de dados
	desconectar_bancodedados(db_handle);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
	return 1;
}

public OnPlayerConnect(playerid)
{
	// Verifica se o jogador tem ou não uma conta
	switch (check_for_account(playerid, db_handle))
	{
		case 0:
		{
			// Registra o jogador
			ShowPlayerDialog(playerid, DIALOGO_REGISTRO, DIALOG_STYLE_PASSWORD, "{FF0000}# {FFFFFF}San Andreas: O Feudo", "{FFFFFF}Digite uma senha segura para que você se registre.", "Registrar", "");

		}
		case 1:
		{
			// Loga o jogador
			ShowPlayerDialog(playerid, DIALOGO_LOGIN, DIALOG_STYLE_PASSWORD, "{FF0000}# {FFFFFF}San Andreas: O Feudo", "{FFFFFF}Digite a sua senha para logar-se", "Logar", "");
		}
	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch (dialogid)
	{
		// Caso seja o diálogo de registro
		case DIALOGO_REGISTRO:
		{
			if(!response) // Caso o jogador cancele o diálogo, kicka (ALTERAR MAIS TARDE PARA A FUNÇÃO PERSONALIZADA!)
			{
				Kick(playerid);
			}
			else // Apertou ENTER ou clicou no 'Registrar'
			{
				// Cadastra o usuário no banco de dados
				cadastrar_player(playerid, MD5_Hash(inputtext, true), db_handle);
			}
			return 1;
		}
		// Caso seja o diálogo de login
		case DIALOGO_LOGIN:
		{
			if(!response) // Caso o jogador cancele o diálogo, kicka (ALTERAR MAIS TARDE PARA A FUNÇÃO PERSONALIZADA!)
			{
				Kick(playerid);
			}
			else // Apertou ENTER ou clicou no 'Login'
			{
				if(logar_player(playerid, MD5_Hash(inputtext, true), db_handle))
				{
					SendClientMessage(playerid, 0xAA3333AA, "You are now logged in!");
				}
				else
				{
					SendClientMessage(playerid, 0xAA3333AA, "LOGIN FAILED.");

					// Mostra o diálogo de novo (fazer leves alterações mais tardes com uma mensagem e uma forma de contar o numero de vezes que o jogador errou a senha)
					ShowPlayerDialog(playerid, DIALOGO_LOGIN, DIALOG_STYLE_PASSWORD, "{FF0000}# {FFFFFF}San Andreas: O Feudo", "{FFFFFF}Digite a sua senha para logar-se", "Logar", "");
				}
			}
			return 1; // We handled a dialog, so return 1. Just like OnPlayerCommandText.
		}
	}
	return 0;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

/* COMANDOS (DCMD) */
