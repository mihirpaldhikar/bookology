const moment = require('moment');
const slugify = require('slugify');
const encryptionManager = require('../managers/encryption.manager');
const {v4: uuidv4} = require('uuid');


const setBooklet = (book) => {
  return {
    _id: uuidv4().replace(/-/g, ''),
    uploader_id: book.uploader_id,
    book_information: {
      isbn: book.isbn,
      name: book.name,
      author: book.author,
      publisher: book.publisher,
    },
    additional_information: {
      description: book.description,
      condition: book.condition,
      images: book.images,
    },
    pricing: {
      original_price: book.original_price,
      selling_price: book.selling_price,
    },
    created_on: {
      date: moment().format('dddd DD MMMM YYYY'),
      time: moment().format('hh:mm:ss'),
    },
    slugs: {
      name: slugify(book.name, {
        lower: true,
        replacement: '_',
      }),
    },
    location: book.location,

  };
};


const getBooklet = (book) => {
  return {
    book_id: book._id,
    uploader_id: book.uploader_id,
    book_information: {
      isbn: book.book_information.isbn,
      name: book.book_information.name,
      author: book.book_information.author,
      publisher: book.book_information.publisher,
    },
    additional_information: {
      description: book.additional_information.description,
      condition: book.additional_information.condition,
      images: book.additional_information.images,
    },
    pricing: {
      original_price: book.pricing.original_price,
      selling_price: book.pricing.selling_price,
    },
    created_on: {
      date: book.created_on.date,
      time: book.created_on.time,
    },
    slugs: {
      name: book.slugs.name,
    },
    location: book.location,
  };
};

const getBookletWithUploader = (book, user) => {
  return {
    book_information: {
      isbn: book.isbn,
      name: book.name,
      author: book.author,
      publisher: book.publisher,
    },
    additional_information: {
      description: book.additional_information.description,
      condition: book.additional_information.condition,
      images: book.additional_information.images,
    },
    pricing: {
      original_price: book.pricing.original_price,
      selling_price: book.pricing.selling_price,
    },
    created_on: {
      date: book.created_on.date,
      time: book.created_on.time,
    },
    slugs: {
      name: book.slugs.name,
    },
    uploader: {
      user_id: user._id,
      username: user.username,
      verified: user.verified,
      profile_picture_url: encryptionManager.decrypt(user.profile_picture_url),
      first_name: user.first_name,
      last_name: user.last_name,
    },
    location: book.location,
  };
};


module.exports = {
  setBooklet,
  getBookletWithUploader,
  getBooklet,
};
