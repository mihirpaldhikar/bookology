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
      categories: book.categories,
      images_collection_id: book.images_collection_id,
      images: book.images,
    },
    pricing: {
      original_price: book.original_price,
      selling_price: book.selling_price,
      currency: book.currency,
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


const updateBook = (book) => {
  return {
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
      categories: book.categories,
      images_collection_id: book.images_collection_id,
      images: book.images,
    },
    pricing: {
      original_price: book.original_price,
      selling_price: book.selling_price,
      currency: book.currency,
    },
    created_on: {
      date: book.date,
      time: book.time,
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
      categories: book.additional_information.categories,
      images_collection_id: book.additional_information.images_collection_id,
      images: book.additional_information.images,
    },
    pricing: {
      original_price: book.pricing.original_price,
      selling_price: book.pricing.selling_price,
      currency: book.pricing.currency,
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
    book_id: book._id,
    book_information: {
      isbn: book.book_information.isbn,
      name: book.book_information.name,
      author: book.book_information.author,
      publisher: book.book_information.publisher,
    },
    additional_information: {
      description: book.additional_information.description,
      condition: book.additional_information.condition,
      categories: book.additional_information.categories,
      images_collection_id: book.additional_information.images_collection_id,
      images: book.additional_information.images,
    },
    pricing: {
      original_price: book.pricing.original_price,
      selling_price: book.pricing.selling_price,
      currency: book.pricing.currency,
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
      username: user.user_information.username,
      verified: user.user_information.verified,
      profile_picture_url: encryptionManager.decrypt(user.user_information.profile_picture),
      first_name: user.user_information.first_name,
      last_name: user.user_information.last_name,
    },
    location: book.location,
  };
};


module.exports = {
  setBooklet,
  updateBook,
  getBookletWithUploader,
  getBooklet,
};
