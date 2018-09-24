require_relative './tradutor'
require 'json'

# Instancia Classe Tradutora informando arquivo de línguas disponíveis
conversao = Tradutor.new

loop do

    # Inicializa variáveis de trabalho
    mensagem, origem, alvo = ''
    ling_origem, ling_alvo = '  '

    # Entrada da língua de Origem para Tradução
    loop do
        conversao.exibe(mensagem, origem)
        puts '0 - Para encerrar'
        puts 'ou entre com a Língua de origem.'
        puts
        print 'Sua Opção: '
        origem = gets.chomp

        conversao.encerra_processo() if (origem == '0')

        ling_origem = conversao.pesquisa_ling(origem)
        mensagem = conversao.testa_ling(ling_origem)

        break unless mensagem
    end

    # Entrada da Língua Alvo da Tradução
    loop do
        conversao.exibe(mensagem, origem, ling_origem, alvo)
        puts '0 - Para encerrar'
        puts 'ou entre com a Língua alvo.'
        puts
        print 'Sua Opção: '
        alvo = gets.chomp

        conversao.encerra_processo if (alvo == '0')
        
        ling_alvo = conversao.pesquisa_ling(alvo)
        mensagem = conversao.testa_ling(ling_alvo, ling_origem)

        break unless mensagem
    end

    # Entrada do Texto a ser Traduzido
    conversao.exibe(mensagem, origem, ling_origem, alvo, ling_alvo)
    puts '0 - Para encerrar'
    puts 'ou entre com o texto a ser traduzido.'
    puts
    print 'Sua Opção: '
    entrada = gets.chomp

    conversao.encerra_processo if (entrada == '0')

    # Tradução
    linguas = ling_origem + '-' + ling_alvo
    saida = JSON.parse(conversao.traduz_texto(entrada, linguas))
    puts "\n"

    # Imprime Status da Tradução
    print '*** '
    case saida["code"].to_i
        when 401
            puts 'Invalid API key'
        when 402
            puts 'Blocked API key'
        when 404
            puts 'Exceeded the daily limit on the amount of translated text'
        when 413
            puts 'Exceeded the maximum text size'
        when 422
            puts 'The text cannot be translated'
        when 501
            puts 'The specified translation direction is not supported'
        when 200
            puts 'Operation completed successfully'
        else
            puts 'Operação com Resultado Desconhecido'
    end

    # Imprime e Grava Resultado da Tradução
    if (saida["code"].to_i == 200)
        puts "\n"
        print 'Resultado: '
        puts saida["text"]

        # Grava Dados da Tradução
        conversao.registra_operacao(saida["lang"], entrada, saida["text"])
    end

    # Verifica se Encerra ou Continua Processo
    puts "\n"
    puts  '0 - Para Encerrar Processo'
    puts  'ou qualquer outra tecla para continuar.'
    puts
    print 'Sua Opção: '
    encerra = gets.chomp

    # Encerra Processo
    conversao.encerra_processo if (encerra == '0')

end


