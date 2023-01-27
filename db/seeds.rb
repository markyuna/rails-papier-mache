# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
#--- cleaning database
puts 'cleaning database'
Booking.destroy_all
Product.destroy_all
User.destroy_all
puts 'database cleaned'

# creating users
puts 'creating user'
user1 = User.create(email: 'marcos@gmail.com', password: 'esternoma')
puts 'user created'

# creating legos

sculptures = [
  { title: 'Lanterne plafonnier',
    description: 'Structure fabriquée avec du carton et des fils de fer, appliquant ensuite plusieurs couches de papier mâché, ensuite le ponçage pour enlever toute imperfection et une couche de gesso avant l’étape final: la peinture.',
    address: '47 rue berger 75001',
    city: 'Paris',
    price: 250,
    stock: 1,
    user: user1 },
  { title: 'Statue grue dorée',
    description: 'Sculpture fabriqué en papier mâché avec lumières leds intégrées à piles',
    address: '16 rue du pont neuf 75001',
    city: 'Paris',
    price: 80,
    stock: 1,
    user: user1 },
  { title: 'Tête de Cerf',
    description: "Tête de cerf 🦌 décoratif fabriqué à la main en papier mâché dépose sur un tableau en verre et métal, léger et respectueux de l'environnement. Décor idéal pour la maison, les hôtels, les festivals, @markpapermache",
    address: '9 rue mansart 75009',
    city: 'Paris',
    price: 80,
    stock: 1,
    user: user1 },
  { title: 'Lampe de chevet',
    description: ' Le design de cette lampe s’adapte à la fois aux styles classiques et modernes. ',
    address: '28 rue jean de la fontaine 75016',
    city: 'Paris',
    price: 50,
    stock: 1,
    user: user1 },
  { title: 'La petite grenouille',
    description: 'Ensemble 2 pièces attaché et fixé, petit porte crayons en papier mâché avec lumières LEDS rouges intégré avec la petite grenouille bleu noir au centre de la base',
    address: '21 rue blondel 75002',
    city: 'Paris',
    price: 50,
    stock: 1,
    user: user1 },
  { title: 'La fontaine magique',
    description: "Mini fontaine faite en carton, plastique et des files dès fer, avec une mini pompe a l’eau connectée à USB et des leds intégré à piles.",
    address: '10 rue rois de sicile 75003',
    city: 'Paris',
    price: 100,
    stock: 1,
    user: user1 },
  { title: 'Boîte à bijoux',
    description: "Mini boîte à bijoux fabriqué en papier mâché",
    address: "59 bis rue jouffroy d'abbans 75017",
    city: 'Paris',
    price: 185,
    stock: 1,
    user: user1 }
]

photos = ['lanterne.jpg', 'grue.jpg', 'cerf.jpg', 'lampe.jpg', 'grenouille.jpg', 'fontaine.jpg', 'boite.jpg']

puts 'creating article'
sculptures.each_with_index do |sculpture, index|
  puts sculpture[:title]
  file = File.open(Rails.root.join("app/assets/images/#{photos[index]}"))
  product = Product.new(sculpture)
  product.photo.attach(io: file, filename: sculpture[:title], content_type: "image/jpg")
  puts 'photo attached'
  product.save!
end
puts 'Article created'
