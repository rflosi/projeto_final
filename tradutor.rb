require 'rest-client'
require 'active_support/all'
Time.zone = 'America/Sao_Paulo'

class Tradutor
    # Inicializa o Hash de linguas
    def initialize
        obtem_key
        cria_linguas
    end


    # Retorna uma lingua ou nulo ao não encontrar a língua selecionada
    def pesquisa_ling(ling)
        return @lingua[ling]
    end

    # Verifica se língua escolhida é válida
    def testa_ling(ling, origem='')
        # testa se língua alvo é igual a origem
        ling = nil if (ling == origem)

        ling ? return : nil ; 'Mensagem........: '+'Opção Inválida'
    end

    # Exibe Tela com o Status do Momento
    def exibe(mensagem='', origem='', ling_origem='  ', alvo='', ling_alvo='  ')
        system "clear"
        puts '********** TRADUTOR DE TEXTOS **********'
        puts
        puts 'Língua Origem...: ' + ling_origem.to_s + ' = ' + origem.to_s
        puts 'Língua Alvo.....: ' + ling_alvo.to_s   + ' = ' + alvo.to_s
        puts mensagem.to_s
        puts
    end

    # Acessa API e traduz o texto baseado nas línguas escolhidas
    def traduz_texto(texto, linguas)
        response = RestClient.get(@url, params: {
            key: @ApiKey,
            text: texto,
            lang: linguas
        });

        return response.body
    end

    def registra_operacao(lang, entrada, saida)
        time = Time.zone.now
        arquivo = time.strftime('%y-%m-%d_%H-%M') + '.txt'

        File.open(arquivo, 'w') do |line|
            line.puts(lang)
            line.puts(entrada)
            line.puts(saida)
        end

        puts "\n"
        puts '*** Registro do Processo Gravado com Sucesso'
        puts
    end

    def encerra_processo
        puts "\n"
        puts '*** Processo Encerrado'
        puts "\n"
        exit
    end



    private

    def obtem_key
        system "clear"
        puts '********** OBTENÇÃO DA API KEY **********'
        puts
        puts '0 - Para encerrar'
        puts 'ou entre com a API Key.'
        puts
        print 'Sua Opção: '
        @ApiKey = gets.chomp
    
        encerra_processo if (@ApiKey == '0')

        @url = 'https://translate.yandex.net/api/v1.5/tr.json/translate'

        system "clear"
    end

    # cria Hash baseado no arquivo texto de possíveis linguas
    def cria_linguas
        loop do
            system "clear"
            puts '********** OBTENÇÃO DE LÍNGUAS **********'
            puts
            puts  '0 - Para encerrar.'
            puts  '1 - Nomenclatura Inglesa.'
            puts  '2 - Nomenclatura Portuguesa.'
            puts
            print 'Sua Opção: '
            opcao = gets.chomp

            encerra_processo if (opcao == '0')

            lingua = ''
            lingua = 'lingua-W3-ENG.txt' if (opcao == '1')
            lingua = 'lingua-POR.txt'    if (opcao == '2')

            if (lingua)
                file = File.open(lingua)

                # Carrega Tabela de Línguas no Hash
                @lingua = Hash.new
                file.each do |line|
                    arr = line.split
                    @lingua[arr[0].downcase] = arr[1]
                end

                puts
                puts  '0 - Para listar as possíveis línguas'
                puts  'ou qualquer outra tecla para ignorar.'
                puts
                print 'Sua Opção: '
                lista = gets.chomp

                # Opção para listar as possíveis Línguas
                if (lista == '0')
                    puts
                    puts @lingua.keys 
                    puts
                    puts  'Qualquer tecla para continuar.'
                    gets.chomp
                end
                break
            end
        end
    end

end