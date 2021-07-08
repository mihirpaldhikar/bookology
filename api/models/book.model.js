const moment = require('moment');
const slugify = require('slugify');
const encryptionManager = require('../managers/encryption.manager');
const {v4: uuidv4} = require('uuid');


const setBooklet = (book) => {
  return {
    _id: uuidv4().replace(/-/g, ''),
    isbn: book.isbn,
    uploader_id: book.uploader_id,
    book_name: book.book_name,
    book_author: book.book_author,
    book_publisher: book.book_publisher,
    description: book.description,
    original_price: book.original_price,
    selling_price: book.selling_price,
    book_condition: book.book_condition,
    book_images_urls: book.book_images_urls,
    upload_date: moment().format('dddd DD MMMM YYYY'),
    upload_time: moment().format('hh:mm:ss'),
    book_name_slug: slugify(book.book_name, {
      lower: true,
      replacement: '_',
    }),
    location: book.location,

  };
};


const getBooklet = (booklet) => {
  return {
    book_id: booklet._id,
    isbn: booklet.isbn,
    book_name: booklet.book_name,
    book_author: booklet.book_author,
    book_publisher: booklet.book_publisher,
    description: booklet.description,
    original_price: booklet.original_price,
    selling_price: booklet.selling_price,
    book_condition: booklet.book_condition,
    book_images_urls: booklet.book_images_urls,
    upload_date: booklet.upload_date,
    upload_time: booklet.upload_time,
    book_name_slug: booklet.book_name_slug,
    location: booklet.location,
  };
};

const getBookletWithUploader = (booklet, user) => {
  return {
    book_id: booklet._id,
    isbn: booklet.isbn,
    book_name: booklet.book_name,
    book_author: booklet.book_author,
    book_publisher: booklet.book_publisher,
    description: booklet.description,
    original_price: booklet.original_price,
    selling_price: booklet.selling_price,
    book_condition: booklet.book_condition,
    book_images_urls: booklet.book_images_urls,
    upload_date: booklet.upload_date,
    upload_time: booklet.upload_time,
    book_name_slug: booklet.book_name_slug,
    uploader: {
      username: user.username,
      verified: user.verified,
      profile_picture_url: encryptionManager.decrypt(user.profile_picture_url),
      first_name: user.first_name,
      last_name: user.last_name,
    },
    location: booklet.location,
  };
};


module.exports = {
  setBooklet,
  getBookletWithUploader,
  getBooklet,
};
