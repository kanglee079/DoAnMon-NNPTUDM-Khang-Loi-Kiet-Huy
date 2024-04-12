const cloudinary = require('cloudinary').v2;

cloudinary.config({ 
    cloud_name: 'dsialaisa', 
    api_key: '571686567894356', 
    api_secret: 'kF76ML6X5BmFVdUNhngKzzuRrbw' 
  })

module.exports = cloudinary;