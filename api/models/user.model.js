const slugify = require('slugify');
const encryptionManager = require('../managers/encryption.manager');
const moment = require('moment');
const Books = require('./book.model');

const getUser = (user) => {
  return {
    user_id: user._id,
    user_information: {
      username: user.user_information.username,
      verified: user.user_information.verified,
      bio: user.user_information.bio,
      profile_picture: encryptionManager.decrypt(user.user_information.profile_picture),
      email: encryptionManager.decrypt(user.user_information.email),
      first_name: user.user_information.first_name,
      last_name: user.user_information.last_name,
    },
    providers: {
      auth: user.providers.auth,
    },
    additional_information: {
      suspended: user.additional_information.suspended,
      email_verified: user.additional_information.email_verified,
    },
    joined_on: {
      date: user.joined_on.date,
      time: user.joined_on.time,
    },
    slugs: {
      username: user.slugs.username,
      first_name: user.slugs.first_name,
      last_name: user.slugs.last_name,
    },
  };
};

const getUserWithBooks = (user, books) => {
  return {
    user_id: user._id,
    user_information: {
      username: user.user_information.username,
      verified: user.user_information.verified,
      bio: user.user_information.bio,
      profile_picture: encryptionManager.decrypt(user.user_information.profile_picture),
      email: encryptionManager.decrypt(user.user_information.email),
      first_name: user.user_information.first_name,
      last_name: user.user_information.last_name,
    },
    providers: {
      auth: user.providers.auth,
    },
    additional_information: {
      suspended: user.additional_information.suspended,
      email_verified: user.additional_information.email_verified,
    },
    joined_on: {
      date: user.joined_on.date,
      time: user.joined_on.time,
    },
    slugs: {
      username: user.slugs.username,
      first_name: user.slugs.first_name,
      last_name: user.slugs.last_name,
    },
    books: books.map((book) => {
      return Books.getBookletWithUploader(book, user);
    }),
  };
};


const setUser = (user) => {
  return {
    _id: user._id,
    user_information: {
      username: user.username,
      verified: false,
      bio: user.bio,
      profile_picture: encryptionManager.encrypt(user.profile_picture_url),
      email: encryptionManager.encrypt(user.email),
      first_name: user.first_name,
      last_name: user.last_name,
    },
    providers: {
      auth: user.auth_provider,
    },
    additional_information: {
      suspended: false,
      email_verified: user.email_verified,
    },
    joined_on: {
      date: moment().format('dddd DD MMMM YYYY'),
      time: moment().format('hh:mm:ss'),
    },
    slugs: {
      username: slugify(user.username, {
        lower: true,
        replacement: '-',
      }),
      first_name: slugify(user.first_name, {
        lower: true,
        replacement: '-',
      }),
      last_name: slugify(user.last_name, {
        lower: true,
        replacement: '-',
      }),
    },
  };
};

const updateUser = (user) => {
  return {
    user_information: {
      username: user.username,
      verified: user.verified,
      bio: user.bio,
      profile_picture: encryptionManager.encrypt(user.profile_picture_url),
      email: user.email,
      first_name: user.first_name,
      last_name: user.last_name,
    },
    providers: {
      auth: user.auth_provider,
    },
    additional_information: {
      suspended: user.suspended,
      email_verified: user.email_verified,
    },
    joined_on: {
      date: user.date,
      time: user.time,
    },
    slugs: {
      username: slugify(user.username, {
        lower: true,
        replacement: '-',
      }),
      first_name: slugify(user.first_name, {
        lower: true,
        replacement: '-',
      }),
      last_name: slugify(user.last_name, {
        lower: true,
        replacement: '-',
      }),
    },
  };
};


module.exports = {
  getUser,
  getUserWithBooks,
  setUser,
  updateUser,
};
