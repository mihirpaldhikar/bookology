const moment = require('moment');
const slugify = require('slugify');
const mongoDb = require("mongodb");
const setBooklet = (booklet) => {
    return {
        uploader_id: mongoDb.ObjectID(booklet.uploader_id),
        isbn: booklet.isbn,
        book_name: booklet.book_name,
        orignal_price: booklet.orignal_price,
        current_price: booklet.current_price,
        book_condition: booklet.book_condition,
        book_image_url: booklet.book_image_url,
        is_used: booklet.is_used,
        upload_date: moment().format('dddd DD MMMM YYYY'),
        upload_time: moment().format('hh:mm:ss'),
        book_name_slug: slugify(booklet.book_name, {
            lower: true,
            replacement: '_'
        })

    }
}


const getBooklet = (booklet) => {
    return {
        book_id: booklet._id,
        uploader_id: booklet.uploader_id,
        isbn: booklet.isbn,
        book_name: booklet.book_name,
        orignal_price: booklet.orignal_price,
        current_price: booklet.current_price,
        book_condition: booklet.book_condition,
        book_image_url: booklet.book_image_url,
        is_used: booklet.is_used,
        upload_date: booklet.upload_date,
        upload_time: booklet.upload_time,
        book_name_slug: booklet.book_name_slug

    }
}


module.exports = {
    setBooklet,
    getBooklet
}