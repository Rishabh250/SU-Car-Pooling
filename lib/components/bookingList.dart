class BookingList {
  final String name;
  final String sysID;
  final String phoneNumber;

  BookingList(
      {required this.name, required this.phoneNumber, required this.sysID});
}

List<BookingList> bookingList = [
  BookingList(
      name: "Rishabh Bansal", phoneNumber: "8859451134", sysID: "2021302586"),
  BookingList(
      name: "Aman Bansal", phoneNumber: "9045291663", sysID: "2021302577"),
];
