/*
 *	@name				O FEUDO - Biblioteca Principal
 *	@version			0.0alpha
 *	@author			Vico
 *	@description		Fun��es �teis para o GM O FEUDO e FS associados
 *
 */
 
/* BIBLIOTECAS */
#include <a_samp>						// Biblioteca padr�o do SA:MP

/* FUN��ES �TEIS */
// Retorna diretamente o nome do jogador, diferente do GetPlayerName
stock return_playername(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid,name,sizeof(name));
	return name;
}