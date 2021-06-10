const slugify = require('slugify');
const encryptionManager = require('../managers/encryption.manager');
const moment = require('moment');
const getUser = (user) => {
  return {
    user_id: user._id,
    username: user.username,
    auth_provider: user.auth_provider,
    is_verified: user.is_verified,
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

const setUser = (user) => {
  return {
    username: user.username,
    auth_provider: user.auth_provider,
    is_verified: false,
    email: encryptionManager.encrypt(user.email),
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
  setUser,
};
