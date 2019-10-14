/*
 *	@name				O FEUDO - GameMode Principal
 *	@version			0.0alpha
 *	@author				Vico
 *	@description		Gamemode 4fun para o SA:MP 0.3DL.
 *
 */
 
/* BIBLIOTECAS */
#include "../include/of_common.inc"		// Biblioteca principal do projeto

/* CONSTANTES */
// dcmd
#define dcmd(%1,%2,%3) if (!strcmp((%3)[1], #%1, true, (%2)) && ((((%3)[(%2) + 1] == '\0') && (dcmd_%1(playerid, ""))) || (((%3)[(%2) + 1] == ' ') && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1

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

/* FUNÇÃO PRINCIPAL DO GM */
main()
{
	print("[INFO] [main]: Servidor operacional!\n");
}

/* FUNÇÕES ÚTEIS */
/* DATABASE */
// Conecta com o banco de dados, retornando o handle caso sucesso
stock db_connect(filename[], &DB:handle)
{
	// Cria uma conexão com o banco de dados
	if((handle = db_open(filename)) == DB:0)
	{
		// Falha
		print("[ERRO] [BD]: Problema na conexão com o banco de dados! O servidor será fechado...\n");
		SendRconCommand("exit");
	}
	else
	{
		// Successo
		print("[INFO] [BD]: Conectado com sucesso com o banco de dados!\n");
	}
}
// Desconecta com o banco de dados
stock db_disconnect(DB:handle)
{
	// Desconecta o banco de dados
	db_close(handle);
}
// Verifica se o jogador já tem ou não registro no banco de dados e registra ou não o jogador no servidor
stock check_for_account(playerid, DB:handle)
{
	new query_sql[40+MAX_PLAYER_NAME];				// SQL da query
	new DBResult:query_result;					// Recebe a id da query para poder limpar depois
	
	format(query_sql, sizeof(query_sql), "SELECT * FROM `players` WHERE `name`='%q'", return_playername(playerid));				 // Formata a string SQL para a consulta
	
	query_result = db_query(handle, query_sql);	// Realiza a consulta no BD
	
    // Retorna o número de linhas da consulta, nesse caso se não houver nenhuma linha signfica que o jogador não tem uma conta no servidor. 
    if(db_num_rows(query_result) == 0) 
    {
		db_free_result(query_result);	// Limpa a query
		return 0;							// Não tem uma conta.
    }
    else 
    {
		db_free_result(query_result);	// Limpa a query
		return 1;							// Tem uma conta.
    }
}

/* CALLBACKS */
/* OnGameModeInit */
public OnGameModeInit()
{
	// Ajusta as informações do servidor
	SetGameModeText("O Feudo v0.0alpha");
	
	// Conecta com o banco de dados
	db_connect(db_filename, db_handle);
	
	// TEMPORARIO
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	return 1;
}

public OnGameModeExit()
{
	// Desconecta com o banco de dados
	db_disconnect(db_handle);
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
			if(!response) Kick(playerid);		// Caso o jogador cancele o diálogo, kicka (ALTERAR MAIS TARDE PARA A FUNÇÃO PERSONALIZADA!)
			
			// FAZER O RESTO...
		}
		// Caso seja o diálogo de login
		case DIALOGO_LOGIN:
		{
			if(!response) Kick(playerid);		// Caso o jogador cancele o diálogo, kicka (ALTERAR MAIS TARDE PARA A FUNÇÃO PERSONALIZADA!)
			
			// FAZER O RESTO...
		}
	}
	return 1;
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
