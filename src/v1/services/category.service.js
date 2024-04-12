const Category = require('../models/category.model'); 
const Product = require('../models/product.model');
const cloudinary = require('../config/cloudinary');

class CategoryService {
    static createCategory = async (categoryData) => {
        try {
            const category = new Category(categoryData);
            await category.save();
            return category;
        } catch (error) {
            throw new Error('Error creating category: ' + error.message);
        }
    }

    static getAllCategory = async () => {
        try {
            return await Category.find({}).populate('products');
        } catch (error) {
            throw new Error('Error fetching categories: ' + error.message);
        }
    }

    static getCategoryBySlug = async (slug) => {
        try {
            const category = await Category.findOne({ slug }).populate('products');
            if (!category) {
                throw new Error('Category not found');
            }
            return category;
        } catch (error) {
            throw new Error('Error fetching category: ' + error.message);
        }
    }

    static updateCategory = async (slug, categoryData) => {
        try {
            const category = await Category.findOneAndUpdate({ slug }, categoryData, { new: true });
            if (!category) {
                throw new Error('Category not found');
            }
            return category;
        } catch (error) {
            throw new Error('Error updating category: ' + error.message);
        }
    }

    static deleteCategory = async (slug) => {
        try {
            const category = await Category.findOne({ slug });
            if (!category) {
                throw new Error('Category not found');
            }
    
            await Product.updateMany({ category: category._id }, { $unset: { category: "" } });
    
            // Using deleteOne instead of remove
            await Category.deleteOne({ _id: category._id });
    
            return category;
        } catch (error) {
            throw new Error('Error deleting category: ' + error.message);
        }
    }

    static getProductsByCategory = async (categoryId) => {
        try {
            const category = await Category.findById(categoryId).populate('products');
            return category.products; 
        } catch (error) {
            throw new Error('Error fetching products by category: ' + error.message);
        }
    }

    static async updateCategoryImage(categoryId, imagePath) {
        try {
          const result = await cloudinary.uploader.upload(imagePath);
          const category = await Category.findByIdAndUpdate(categoryId, { image_url: result.url }, { new: true });
          if (!category) {
            throw new Error('Category not found');
          }
          return category;
        } catch (error) {
          throw new Error('Error updating category image: ' + error.message);
        }
      }
    
}

module.exports = CategoryService;
