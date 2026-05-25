const { DataTypes } = require('sequelize');

const sequelize = require('./index');
const Category = require('./category');

const Channel = sequelize.define(
  'sports_channels',
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

    image: {
      type: DataTypes.TEXT,
      allowNull: true,
      defaultValue: '',
    },

    link: {
      type: DataTypes.TEXT,
      allowNull: false,
    },

    categoryId: {
      type: DataTypes.INTEGER,

      allowNull: false,

      field: 'category_id',

      references: {
        model: 'sports_categories',
        key: 'id',
      },
    },
  },

  {
    tableName: 'sports_channels',

    timestamps: false,

    freezeTableName: true,
  }
);

Category.hasMany(Channel, {
  foreignKey: 'categoryId',
  sourceKey: 'id',
});

Channel.belongsTo(Category, {
  foreignKey: 'categoryId',
  targetKey: 'id',
});

module.exports = Channel;