const slugify = require('slugify');
const encryptionManager = require('../managers/encryption.manager');
const moment = require('moment');
const Books = require('./book.model');

const getUser = (user) => {
  return {
    user_id: user._id,
    username: user.username,
    auth_provider: user.auth_provider,
    bio: user.bio,
    verified: user.verified,
    suspended: user.suspended,
    email_verified: user.email_verified,
    email: encryptionManager.decrypt(user.email),
    profile_picture_url: encryptionManager.decrypt(user.profile_picture_url),
    first_name: user.first_name,
    last_name: user.last_name,
    joined_date: user.joined_date,
    joined_time: user.joined_time,
    username_slug: user.username_slug,
    first_name_slug: user.first_name_slug,
    last_name_slug: user.last_name_slug,
  };
};

const getUserProfile = (user) => {
  return {
    username: user.username,
    bio: user.bio,
    verified: user.verified,
    suspended: user.suspended,
    email: encryptionManager.decrypt(user.email),
    profile_picture_url: encryptionManager.decrypt(user.profile_picture_url),
    first_name: user.first_name,
    last_name: user.last_name,
    joined_date: user.joined_date,
    joined_time: user.joined_time,
    username_slug: user.username_slug,
    first_name_slug: user.first_name_slug,
    last_name_slug: user.last_name_slug,
  };
};


const getUserProfileWithBooks = (user, books) => {
  return {
    username: user.username,
    bio: user.bio,
    verified: user.verified,
    suspended: user.suspended,
    email: encryptionManager.decrypt(user.email),
    profile_picture_url: encryptionManager.decrypt(user.profile_picture_url),
    first_name: user.first_name,
    last_name: user.last_name,
    joined_date: user.joined_date,
    joined_time: user.joined_time,
    username_slug: user.username_slug,
    first_name_slug: user.first_name_slug,
    last_name_slug: user.last_name_slug,
    books: books.map((book) => {
      return Books.getBooklet(book);
    }),
  };
};

const setUser = (user) => {
  return {
    _id: user._id,
    username: user.username,
    auth_provider: user.auth_provider,
    bio: user.bio,
    verified: false,
    suspended: false,
    email_verified: user.email_verified,
    email: encryptionManager.encrypt(user.email),
    password: encryptionManager.encrypt(user.password),
    profile_picture_url: encryptionManager.encrypt(user.profile_picture_url),
    first_name: user.first_name,
    last_name: user.last_name,
    joined_date: moment().format('dddd DD MMMM YYYY'),
    joined_time: moment().format('hh:mm:ss'),
    username_slug: slugify(user.username, {
      lower: true,
      replacement: '-',
    }),
    first_name_slug: slugify(user.first_name, {
      lower: true,
      replacement: '-',
    }),
    last_name_slug: slugify(user.last_name, {
      lower: true,
      replacement: '-',
    }),
  };
};


module.exports = {
  getUser,
  getUserProfile,
  getUserProfileWithBooks,
  setUser,
};
