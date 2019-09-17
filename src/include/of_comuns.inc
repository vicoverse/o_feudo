/*
 *	@name				O FEUDO - Biblioteca Principal
 *	@version			0.0alpha
 *	@author			Vico
 *	@description		Funções úteis para o projeto O FEUDO
 *
 */
 
/* BIBLIOTECAS */
#include <a_samp>						// Biblioteca padrão do SA:MP

/* FUNÇÕES */
/* Funções úteis */
// Retorna a string do nick do player
stock ReturnPlayerName(playerid)
{
	new nick[MAX_PLAYER_NAME + 1];
	GetPlayerName(playerid, nick, sizeof(nick));
	
	return nick;
}
/* Banco de Dados */
// Conectar com o Banco de Dados
stock ConectarBD(nome_arquivo[], DB:bd_handle)
{
	// Cria a conexão com o banco de dados
	if((bd_handle = db_open(nome_arquivo)) == DB:0)
	{
		// Caso de erro
		print("[ERRO] [BD]: Não foi possível conectar com o banco de dados! O servidor será encerrado!");
		SendRconCommand("exit");
	}
	else
	{
		// Caso consiga
		print("[INFO] [BD]: Conexão com banco de dados realizada com sucesso!");
	}
}
// Encerrar conexão com o Banco de Dados
stock DesconectarBD(DB:bd_handle)
{
	// Fecha a conexão com o banco de dados
	print("[INFO] [BD]: Encerrando conexão com o banco de dados...");
	db_close(bd_handle);
	print("[INFO] [BD]: Conexão com banco de dados encerrada com sucesso!");
}
// FUNÇÕES ÚTEIS

// Procedimento de login do jogador
stock LoginPlayer(DB:bd_handle, playerid)
{
	new nick[MAX_PLAYER_NAME + 1] = ReturnPlayerName(playerid);

}

// Sincronizar informações do player com banco de dados
stock SyncPlayer(DB:bd_handle, playerid)
{

}

// Sincronizar informações de todos os players com banco de dados
stock SyncAllPlayers(DB:bd_handle)
{

}