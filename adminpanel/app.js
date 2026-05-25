require('dotenv').config();

const express = require('express');
const sequelize = require('./models');
const Category = require('./models/category');
const Channel = require('./models/channel');
const { admin, adminRouter } = require('./admin');

const app = express();

app.use(express.json());

app.get('/', (req, res) => {
  res.json({
    success: true,
    message: 'Server running successfully',
  });
});

app.use(admin.options.rootPath, adminRouter);

const start = async () => {
  try {
    await sequelize.authenticate();
    console.log('Database connected');

    await sequelize.sync({ alter: true });
    console.log('Tables synced');

    app.listen(process.env.PORT, () => {
      console.log(`Server running on port ${process.env.PORT}`);
      console.log(
        `AdminJS: http://localhost:${process.env.PORT}${admin.options.rootPath}`
      );
    });
  } catch (error) {
    console.error(error);
  }
};

start();