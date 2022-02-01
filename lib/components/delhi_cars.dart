class DelhiCars {
  final String? driverName;
  final String? city;
  final String? driverCar;
  final String? price;
  final String? carNumber;
  final String? seats;
  final String? occupation;
  final String? sysID;

  DelhiCars(
      {required this.occupation,
      required this.sysID,
      required this.driverName,
      required this.city,
      required this.driverCar,
      required this.price,
      required this.carNumber,
      required this.seats});
}

List<DelhiCars> getDelhiCars = [
  DelhiCars(
      driverName: "Rishabh Bansal",
      driverCar: "Swift Dzire",
      price: "100",
      carNumber: "UP13 AC0000",
      seats: '4',
      occupation: 'Student',
      sysID: '2021302586',
      city: 'Delhi'),
  DelhiCars(
      driverName: "Aman Bansal",
      driverCar: "Hyundai Venue",
      price: "100",
      carNumber: "UP13 AC0000",
      seats: '5',
      occupation: 'Faculty',
      sysID: '2021302586',
      city: 'Delhi'),
  DelhiCars(
      driverName: "Subham Bansal",
      driverCar: "Baleno",
      price: "100",
      carNumber: "UP13 AC0000",
      seats: '4',
      occupation: 'Faculty',
      sysID: '2021302586',
      city: 'Delhi'),
];
