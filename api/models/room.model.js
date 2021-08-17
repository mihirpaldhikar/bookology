const createRoom = (roomData) => {
  return {
    _id: roomData.room_id,
    book_id: roomData.book_id,
    title: roomData.time,
    room_icon: roomData.room_icon,
    room_owner: roomData.room_owner,
    users: roomData.users,
    created_on: {
      date: roomData.date,
      time: roomData.time,
    },
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
    created_on: {
      date: roomData.created_on.date,
      time: roomData.created_on.time,
    },
  };
};

module.exports = {
  createRoom,
  getRoom,
};
