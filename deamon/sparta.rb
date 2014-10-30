# -*- coding: utf-8 -*-

require 'date'

class Commission
  attr_accessor :type
  attr_accessor :quantite
  attr_accessor :prix_vente
  attr_accessor :payer
  attr_accessor :date
  def initialize(type, quantite, prix_vente, payer, date)
    @type = type
    @quantite = quantite
    @prix_vente = prix_vente
    @payer = payer
    @date = date
  end
end

class Person
  attr_accessor :name
  attr_accessor :surname
  def initialize(name, surname)
    @name = name
    @surname = surname
    @commissions = []
  end
  def append(type, quantite, prix_vente, payer, date)
    @commissions << Commission.new(type, quantite, prix_vente, payer, date)
  end
  def mod_payer(date, payer)
    @commissions.each do |com|
      if com.date == date
        com.payer = payer
      end
    end
  end
  def mod_prix_vente(date, prix_vente)
    @commissions.each do |com|
      if com.date == date
        com.prix_vente = prix_vente
      end
    end
  end
  def list_to_pay
    puts "---- #{@name} #{@surname} ---"
    nb = 0
    @commissions.each do |com|
      if com.payer != com.prix_vente
        rest = com.prix_vente - com.payer
        nb += rest
        puts "#{com.date} [#{com.prix_vente}€ de #{com.type}] Dette : #{rest}€"
      end
    end
    puts "Total des dettes : #{nb}€"
  end
  def get_money
    nb = 0
    @commissions.each do |com|
      nb += com.payer
    end
    nb
  end
  def get_dette
    nb = 0
    @commissions.each do |com|
      nb += com.prix_vente - com.payer
    end
    nb
  end
  def put_conta
    puts "---- #{@name} #{@surname} ---"
    @commissions.each do |com|
      rest = com.prix_vente - com.payer
      puts "#{com.date} [#{com.prix_vente}€ de #{com.type}] Dette : #{rest}€"
    end
    puts "\n"
  end
  def get_weed
    nb = 0
    @commissions.each do |com|
      if com.type == "Weed"
        nb += com.quantite
      end
    end
    nb
  end
end

class Sparta
  def initialize
    @conta = []
  end
  def append_person(name, surname)
    @conta << Person.new(name, surname)
  end
  def search_person(name)
    @conta.each do |person|
      if person.name == name
        return person
      end
    end
    return nil
  end
  def rm_person(person)
    @conta.delete(person)
  end
  def append_to(person, type, quantite, prix_vente, payer)
    person.append(type, quantite, prix_vente, payer, Time.now.to_s)
  end
  def list_to_pay
    @conta.each do |person|
      person.list_to_pay
    end
  end
  def get_money
    nb = 0
    @conta.each do |person|
      nb += person.get_money
    end
    nb
  end
  def get_dette
    nb = 0
    @conta.each do |person|
      nb += person.get_dette
    end
    nb
  end
  def get_weed
    nb = 0
    @conta.each do |person|
      nb += person.get_weed
    end
    nb
  end
  def put_conta
    @conta.each do |person|
      person.put_conta
    end
  end
  def put_clients
    @conta.each do |person|
      puts("#{person.name} #{person.surname}")
    end
  end
end

def sparta_exec(line, sparta)
  lines = line.split
  sparta = Marshal.load(File.read('conta.sp'))
  if lines[0] == "list"
    sparta.list_to_pay
  elsif lines[0] == "add_person"
    sparta.append_person(lines[1], lines[2])
  elsif lines[0] == "add_to"
    person = sparta.search_person(lines[1])
    if person == nil
      return (puts("Personne introuvable"))
    end
    print("Type : ")
    type = gets.strip
    print("Quantite : ")
    quantite = gets.to_f
    print("Prix de Vente : ")
    prix_vente = gets.to_i
    print("Payer : ")
    payer = gets.to_i
    sparta.append_to(person, type, quantite, prix_vente, payer)
  elsif lines[0] == "exit"
    exit
  elsif lines[0] == "conta"
    sparta.put_conta
  elsif lines[0] == "clients"
    sparta.put_clients
  elsif lines[0] == "dette"
    person = sparta.search_person(lines[1])
    if person == nil
      return (puts("Personne introuvable"))
    end
    person.list_to_pay
  elsif lines[0] == "total"
    puts "Total : #{sparta.get_money}€"
  elsif lines[0] == "total_of"
    person = sparta.search_person(lines[1])
    if person == nil
      return (puts("Personne introuvable"))
    end
    puts "Total : #{person.get_money}€"
  elsif lines[0] == "rm_person"
    person = sparta.search_person(lines[1])
    if person == nil
      return (puts "Personne introuvable")
    end
    sparta.rm_person(person)
  elsif lines[0] == "sparta"
    caisse = sparta.get_money
    credit = sparta.get_dette
    final = caisse + credit
    puts "Caisse : #{caisse}"
    puts "Credit : #{credit}"
    puts "Final : #{final}"
    puts "Weed écoulé : #{sparta.get_weed}"
  else
    puts("--- Help ---")
    puts("list -> Liste les ventes à crédit")
    puts("add_person [name] [surname] -> Ajoute un personne à la conta")
    puts("add_to [name] -> Ajoute une commande à une personne")
    puts("exit -> Quitte")
    puts("conta -> Affiche la contabilité")
    puts("clients -> Affiche la liste des clients")
    puts("dette [name] -> Affiche les dettes d'une personne")
    puts("total -> Affiche le total des recettes")
    puts("total_of [name] -> Affiche le total des recettes d'un client")
    puts("rm_person [name] -> Supprime une personne (/!\\)")
    puts("sparta -> Affiche la sparta-conclusion")
  end
  File.open("conta.sp", "w") { |f| f.write(Marshal.dump(sparta)) }
end

def main
  if File.exist?("conta.sp")
    sparta = Marshal.load(File.read('conta.sp'))
  else
    sparta = Sparta.new
    File.open("conta.sp", 'w') { |f| f.write(Marshal.dump(sparta)) }
  end
  puts "   _____ _____        _____ _______       "
  puts "  / ____|  __ \\ /\\   |  __ \\__   __|/\\    "
  puts " | (___ | |__) /  \\  | |__) | | |  /  \\   "
  puts "  \\___ \\|  ___/ /\\ \\ |  _  /  | | / /\\ \\  "
  puts "  ____) | |  / ____ \\| | \\ \\  | |/ ____ \\ "
  puts " |_____/|_| /_/    \\_\\_|  \\_\\ |_/_/    \\_\\"
  puts "\n\n"
  print "sparta &> "
  while line = gets
    sparta_exec(line, sparta)
    puts "\n\n"
    print "sparta &> "
  end
end

main  
