/*
 *	@name				O FEUDO - Biblioteca Principal
 *	@version			0.0alpha
 *	@author			Vico
 *	@description		Funções úteis para o GM O FEUDO e FS associados
 *
 */
 
/* BIBLIOTECAS */
#include <a_samp>						// Biblioteca padrão do SA:MP

/* FUNÇÕES ÚTEIS */
// Retorna diretamente o nome do jogador, diferente do GetPlayerName
stock return_playername(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid,name,sizeof(name));
	return name;
}
