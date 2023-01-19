def da_boas_vindas
  puts "Olá, bem vindo ao Foge-Foge"
  puts "Qual o seu nome?"
  nome = gets.strip
end

def desenha_mapa mapa
  puts mapa
end

def pede_movimento
  puts "Para qual lado você que ir?"
  direcao = gets.strip.upcase
end