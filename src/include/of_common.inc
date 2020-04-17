/*
 *	@name				O FEUDO - Biblioteca Principal
 *	@version			0.0alpha
 *	@author			Vico
 *	@description		Funções úteis para o GM O FEUDO e FS associados
 *
 */
 
/* BIBLIOTECAS */
#include <a_samp>						// Biblioteca padrão do SA:MP
#include "../include/MD5.inc"				// Biblioteca para gerar hash MD5

/* DEFINIÇÕES */
forward sync_players(DB:handle);	// Para sincronizar os jogadores repetidamente

/* FUNÇÕES DE BANCO DE DADOS */
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
// Tenta logar o player checando a senha com o banco de dados
stock logar_player(playerid, password[], DB:handle)
{
	new query_sql[48+MAX_PLAYER_NAME];				// SQL da query
	new DBResult:query_result;					// Recebe a id da query para poder limpar depois
	new db_password[128];							// Senha no banco de dados
	
	// Formata a string SQL para a consulta
	format(query_sql, sizeof(query_sql), "SELECT * FROM `players` WHERE `name`='%q' LIMIT 1", return_playername(playerid));
	
	query_result = db_query(handle, query_sql);	// Realiza a consulta no BD
	
	// Salva a senha na variável
	db_get_field_assoc(query_result, "senha", db_password, sizeof db_password);
	
	// Compara diretamente as duas senhas (na verdade os dois hashes), se batem retorna 1 para confirmar o login
	if (!strcmp(password, db_password, true))
	{
		// Transfere os dados do banco para PVars para usu posterior
		SetPVarInt(playerid, "level", db_get_field_assoc_int(query_result, "level"));
		SetPVarInt(playerid, "score", db_get_field_assoc_int(query_result, "score"));
		SetPVarInt(playerid, "skin", db_get_field_assoc_int(query_result, "skinid"));
		SetPVarInt(playerid, "money", db_get_field_assoc_int(query_result, "money"));
	
		db_free_result(query_result); // Limpa a query
		return 1; // Acertou
	}
	db_free_result(query_result); // Limpa a query
	return 0; // Errou
}
// Cadastra o usuário no banco de dados
stock cadastrar_player(playerid, password[], DB:handle)
{
	new query_sql[255];								// SQL da query
	
	// Formata a string SQL para a inserção
	format(query_sql, sizeof(query_sql), "INSERT INTO `players` (`name`, `senha`, `level`, `score`, `skinid`, `money`) VALUES ('%q', '%q', '0', '0', '-1', '0');", return_playername(playerid), password);
	
	// Realiza a query
	db_free_result(db_query(handle, query_sql));
}
// Envia os dados das Pvars para o banco
stock sincronizar_banco(playerid, DB:handle)
{
	new query_sql[255];						// SQL da query	
	new level, score, skinid, money;		// Variáveis temporárias
	
	// Formata a string SQL para a inserção
	format(query_sql, sizeof(query_sql), "UPDATE players SET level = %i, score = %i, skinid = %i, money = %i WHERE name = %q;", level, score, skinid, money, return_playername(playerid));
	// Realiza a UPDATE e logo em seguida limpa a query
	db_free_result(db_query(handle, query_sql));	
}

// Função que sincroniza os dados de todos os players no servidor
public sync_players(DB:handle)
{
	new count = 0;	// Contador para mostrar na mensagem abaixo!
	// Loop em todos os possíveis players
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		// Se tem alguém conectado...
		if(IsPlayerConnected(i))
		{
			// ...chama a função de sincronizar os dados do jogador!
			sincronizar_banco(i, handle);
			count = count+1;
		}
		// ...senão pula para o próximo ID
	}
	// Avisa no console quantos jogadores online e sincronizados
	printf("[info] [main] %i jogadores conectados e sincronizados!", count);
	
	return 1;
}

/* FUNÇÕES ÚTEIS */
// Retorna diretamente o nome do jogador, diferente do GetPlayerName
stock return_playername(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid,name,sizeof(name));
	return name;
}

// Substituir caracteres em uma string
stock strreplace(string[], const search[], const replacement[], bool:ignorecase = false, pos = 0, limit = -1, maxlength = sizeof(string)) {
    // No need to do anything if the limit is 0.
    if (limit == 0)
        return 0;
    
    new
             sublen = strlen(search),
             replen = strlen(replacement),
        bool:packed = ispacked(string),
             maxlen = maxlength,
             len = strlen(string),
             count = 0
    ;
    
    
    // "maxlen" holds the max string length (not to be confused with "maxlength", which holds the max. array size).
    // Since packed strings hold 4 characters per array slot, we multiply "maxlen" by 4.
    if (packed)
        maxlen *= 4;
    
    // If the length of the substring is 0, we have nothing to look for..
    if (!sublen)
        return 0;
    
    // In this line we both assign the return value from "strfind" to "pos" then check if it's -1.
    while (-1 != (pos = strfind(string, search, ignorecase, pos))) {
        // Delete the string we found
        strdel(string, pos, pos + sublen);
        
        len -= sublen;
        
        // If there's anything to put as replacement, insert it. Make sure there's enough room first.
        if (replen && len + replen < maxlen) {
            strins(string, replacement, pos, maxlength);
            
            pos += replen;
            len += replen;
        }
        
        // Is there a limit of number of replacements, if so, did we break it?
        if (limit != -1 && ++count >= limit)
            break;
    }
    
    return count;
}
