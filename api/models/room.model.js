const createRoom = (roomData) => {
  return {
    _id: roomData.room_id,
    book_id: roomData.book_id,
    title: roomData.title,
    room_icon: roomData.room_icon,
    room_owner: roomData.room_owner,
    users: roomData.users,
    created_on: roomData.created_on,
  };
};

const getRoom = (roomData) => {
  return {
    room_id: roomData._id,
    book_id: roomData.book_id,
    title: roomData.time,
    room_icon: roomData.room_icon,
    room_owner: roomData.room_owner,
    users: roomData.users,
    created_on: roomData.created_on,
  };
};

module.exports = {
  createRoom,
  getRoom,
};
