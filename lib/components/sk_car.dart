class SKCars {
  final String? driverName;
  final String? driverCar;
  final String? city;
  final String? price;
  final String? carNumber;
  final String? seats;
  final String? occupation;
  final String? sysID;

  SKCars(
      {required this.occupation,
      required this.sysID,
      required this.city,
      required this.driverName,
      required this.driverCar,
      required this.price,
      required this.carNumber,
      required this.seats});
}

List<SKCars> getSKCars = [
  SKCars(
      driverName: "Rishabh Bansal",
      driverCar: "Swift Dzire",
      price: "40",
      carNumber: "UP13 AC0000",
      seats: '4',
      occupation: 'Student',
      sysID: '2021302586',
      city: 'Sikandrabad'),
  SKCars(
      driverName: "Aman Bansal",
      driverCar: "Hyundai Venue",
      price: "40",
      carNumber: "UP13 AC0000",
      seats: '5',
      occupation: 'Faculty',
      sysID: '2021302586',
      city: 'Sikandrabad'),
  SKCars(
      driverName: "Subham Bansal",
      driverCar: "Baleno",
      price: "40",
      carNumber: "UP13 AC0000",
      seats: '4',
      occupation: 'Faculty',
      sysID: '2021302586',
      city: 'Sikandrabad'),
];
