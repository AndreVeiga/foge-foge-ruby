require_relative "ui"
require_relative "heroi"

def le_mapa numero
  arquivo = "mapa#{numero}.txt"
  texto = File.read arquivo
  mapa = texto.split "\n"
end

def encontra_jogador mapa
  heroi = "H"

  mapa.each_with_index do |linha_atual, linha|
    linha_atual = mapa[linha]

    coluna = linha_atual.index heroi

    if coluna
      heroi = Heroi.new
      heroi.linha = linha
      heroi.coluna = coluna
      return heroi  
    end    
  end

  nil
end

def posicao_valida? mapa, posicao
  linhas = mapa.size
  colunas = mapa[0].size

  estourou_linhas = posicao[0] < 0 ||  posicao[0] >= linhas 
  estourou_colunas = posicao[1] < 0 || posicao[1] >= colunas

  if estourou_linhas || estourou_colunas
    return false
  end

  posicao_atual = mapa[posicao[0]] [posicao[1]]

  if posicao_atual == "X" || posicao_atual == "F"
    return false
  end

  true
end

def move_fantasma mapa, linha, coluna, novo_mapa
  posicoes = posicoes_validas_a_partir_de mapa, [linha, coluna], novo_mapa

  return if posicoes.empty?

  aleatorio = rand posicoes.size
  posicao = posicoes[aleatorio]

  mapa[linha][coluna] = " "
  novo_mapa[posicao[0]][posicao[1]] = "F"
end

def move_fantasmas mapa
  fantasma = "F"
  novo_mapa = copia_mapa mapa

  mapa.each_with_index do |linha_atual, linha| 
    linha_atual.chars.each_with_index do |caractere_atual, coluna|
      if caractere_atual == fantasma 
        move_fantasma mapa, linha, coluna, novo_mapa
      end 
    end 
  end

  novo_mapa
end

def soma_vetor vetor1, vetor2
  [vetor1[0] + vetor2[0], vetor1[1] + vetor2[1]]
end

def posicoes_validas_a_partir_de mapa, posicao, novo_mapa
  posicoes = []
  movimentos = [[+1, 0], [0, +1], [-1, 0],[0, -1]]

  movimentos.each do |movimento|
    nova_posicao = soma_vetor movimento, posicao
    if posicao_valida?(mapa, nova_posicao) && posicao_valida?(novo_mapa, nova_posicao)
      posicoes << nova_posicao 
    end
  end
  
  posicoes
end

def copia_mapa mapa
  novo_mapa = mapa.join("\n").tr("F", " ").split("\n")
end

def jogador_perdeu? mapa
  !encontra_jogador(mapa)
end

def executa_remocao mapa, posicao, quantidade
  return if mapa[posicao.linha][posicao.coluna] == "X"

  posicao.remove_do mapa
  remove mapa, posicao.anda_direita, quantidade - 1
  remove mapa, posicao.anda_esquerda, quantidade - 1
  remove mapa, posicao.anda_cima, quantidade - 1
  remove mapa, posicao.anda_baixo, quantidade - 1
end

def remove mapa, posicao, quantidade
  executa_remocao(mapa, posicao, quantidade)  if quantidade > 0
end

def joga nome
   mapa = le_mapa 3

   while true
      desenha_mapa mapa

      direcao = pede_movimento

      heroi = encontra_jogador mapa

      nova_posicao = heroi.calcula_nova_posicao direcao
      
      next if !posicao_valida? mapa, nova_posicao.to_array

      heroi.remove_do mapa
            
      if mapa[nova_posicao.linha][nova_posicao.coluna] == "*"
        remove(mapa, nova_posicao, 4)
      end

      nova_posicao.coloca_no mapa

      mapa = move_fantasmas mapa

      if jogador_perdeu? mapa
        game_over
        break
      end
   end
end

def inicia_jogo
  nome = da_boas_vindas
  joga nome 
end