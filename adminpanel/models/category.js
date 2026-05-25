const { DataTypes } = require('sequelize');

const sequelize = require('./index');

const Category = sequelize.define(
  'sports_categories',
  {
    id: {
      type: DataTypes.INTEGER,

      autoIncrement: true,

      primaryKey: true,
    },

    name: {
      type: DataTypes.STRING,

      allowNull: false,
    },
  },

  {
    tableName: 'sports_categories',

    timestamps: false,

    freezeTableName: true,
  }
);

module.exports = Category;