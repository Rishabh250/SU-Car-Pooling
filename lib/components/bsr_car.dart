class BSR {
  final String? driverName;
  final String? driverCar;
  final String? price;
  final String? carNumber;
  final String? seats;
  final String? occupation;
  final String? sysID;
  final String? city;

  BSR(
      {required this.occupation,
      required this.sysID,
      required this.city,
      required this.driverName,
      required this.driverCar,
      required this.price,
      required this.carNumber,
      required this.seats});
}

List<BSR> getBSRCars = [
  BSR(
      driverName: "Rishabh Bansal",
      driverCar: "Swift Dzire",
      price: "60",
      carNumber: "UP13 AC0000",
      seats: '4',
      occupation: 'Student',
      sysID: '2021302586',
      city: 'Bulandshahr'),
  BSR(
      driverName: "Aman Bansal",
      driverCar: "Hyundai Venue",
      price: "60",
      carNumber: "UP13 AC0000",
      seats: '5',
      occupation: 'Faculty',
      sysID: '2021302586',
      city: 'Bulandshahr'),
  BSR(
      driverName: "Subham Bansal",
      driverCar: "Baleno",
      price: "60",
      carNumber: "UP13 AC0000",
      seats: '4',
      occupation: 'Faculty',
      sysID: '2021302586',
      city: 'Bulandshahr'),
  BSR(
      driverName: "Surbhi Bansal",
      driverCar: "Renault Triber",
      price: "60",
      carNumber: "UP13 AC0000",
      seats: '7',
      occupation: 'Student',
      sysID: '2021302586',
      city: 'Bulandshahr'),
];
