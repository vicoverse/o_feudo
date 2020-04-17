/*
 *	@name				O FEUDO - Biblioteca de Banco de Dados
 *	@version			0.0alpha
 *	@author			Vico
 *	@description		Funções úteis para conexão com o banco de dados
 *
 */

/* BIBLIOTECAS */

#include <a_samp>								// Biblioteca padrão do SA:MP
#include "../include/of_common.inc"				// Biblioteca padrão do projeto

/* FUNÇÕES */

// Abrir o arquivo com o script inicial em SQL e ler em uma string
stock ler_arquivoSQL()
{
	// Abrir "bd_script.sql" no modo SOMENTE LEITURA
	new File:handle = fopen("bd_script.sql", io_read),
	 
	// Criar a variável que armazenará o código SQL (Ctrl+A no Notepad++ pra conferir o tamanho a colocar)
	script_sql[512];
	 
	// Verificar se o arquivo foi aberto com sucesso
	if(handle)
	{
		// Sucesso
	 
		// Ler todo o arquivo
		while(fread(handle, script_sql)) print(script_sql);
	 
		// Fechar o arquivo
		fclose(handle);
		
		// Substitui todoas as quebras de linha por espaços
		strreplace(script_sql, "\n", " ");
		
		// Retorna o SQL em uma única string
		return script_sql;
	}
	else
	{
		// Erro. Avisa no console e fecha o servidor.
		print("[ERRO] [BD]: Problema ao carregar o arquivo SQL para geração do banco de dados! O servidor será fechado...\n");
		SendRconCommand("exit");
		return "";
	}
}

// Conecta com o banco de dados, retornando o handle caso sucesso
stock conectar_bancodedados(nome_arquivo[], &DB:handle)
{
	// Cria uma conexão com o banco de dados
	if((handle = db_open(nome_arquivo)) == DB:0)
	{
		// Falha
		print("[ERRO] [BD]: Problema na conexão com o banco de dados! O servidor será fechado...\n");
		SendRconCommand("exit");
	}
	else
	{
		// Successo
		// Cria as tabelas necessárias caso seja a primeira inicialização
		db_free_result(db_query(handle, ler_arquivoSQL()));
		// Informa que foi possível conectar
		print("[INFO] [BD]: Conectado com sucesso com o banco de dados!\n");
	}
}

// Desconecta com o banco de dados
stock desconectar_bancodedados(DB:handle)
{
	// Desconecta o banco de dados
	db_close(handle);
}