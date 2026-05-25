const AdminJS = require('adminjs');
const AdminJSExpress = require('@adminjs/express');
const AdminJSSequelize = require('@adminjs/sequelize');
const session = require('express-session');

const Category = require('./models/category');
const Channel = require('./models/channel');

AdminJS.registerAdapter(AdminJSSequelize);

const admin = new AdminJS({
  rootPath: '/admin',

  resources: [
    {
      resource: Category,
      options: {
        id: 'categories',
        navigation: {
          name: 'Content',
          icon: 'Folder',
        },

        properties: {
          id: {
            isVisible: {
              list: true,
              filter: true,
              show: true,
              edit: false,
            },
          },
        },
      },
    },

    {
      resource: Channel,

      options: {
        id: 'channels',

        navigation: {
          name: 'Content',
          icon: 'Video',
        },

        listProperties: [
          'id',
          'name',
          'image',
          'link',
          'categoryId',
        ],

        editProperties: [
          'name',
          'image',
          'link',
          'categoryId',
        ],

        filterProperties: [
          'name',
          'categoryId',
        ],

        showProperties: [
          'id',
          'name',
          'image',
          'link',
          'categoryId',
        ],

        properties: {
          id: {
            isVisible: {
              list: true,
              filter: true,
              show: true,
              edit: false,
            },
          },

          image: {
            type: 'string',
          },

          link: {
            type: 'string',
          },

          categoryId: {
            reference: 'categories',
          },
        },
      },
    },
  ],

  branding: {
    companyName: 'Express Admin Panel',
    softwareBrothers: false,
  },
});

const adminRouter = AdminJSExpress.buildAuthenticatedRouter(
  admin,

  {
    authenticate: async (email, password) => {
      if (
        email === 'user@gmail.com' &&
        password === 'password'
      ) {
        return { email };
      }

      return null;
    },

    cookieName: 'adminjs',

    cookiePassword: process.env.SESSION_SECRET,
  },

  null,

  {
    store: new session.MemoryStore(),

    resave: false,

    saveUninitialized: true,

    secret: process.env.SESSION_SECRET,

    cookie: {
      httpOnly: true,
      secure: false,
    },

    name: 'adminjs',
  }
);

module.exports = {
  admin,
  adminRouter,
};