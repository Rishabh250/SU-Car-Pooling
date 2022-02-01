class NoidaCars {
  final String? driverName;
  final String? driverCar;
  final String? city;
  final String? price;
  final String? carNumber;
  final String? seats;
  final String? occupation;
  final String? sysID;

  NoidaCars(
      {required this.occupation,
      required this.sysID,
      required this.driverName,
      required this.driverCar,
      required this.city,
      required this.price,
      required this.carNumber,
      required this.seats});
}

List<NoidaCars> getNoidaCars = [
  NoidaCars(
      driverName: "Rishabh Bansal",
      driverCar: "Swift Dzire",
      price: "80",
      carNumber: "UP13 AC0000",
      seats: '4',
      occupation: 'Student',
      sysID: '2021302586',
      city: 'Noida'),
  NoidaCars(
      driverName: "Aman Bansal",
      driverCar: "Hyundai Venue",
      price: "80",
      carNumber: "UP13 AC0000",
      seats: '5',
      occupation: 'Faculty',
      sysID: '2021302586',
      city: 'Noida'),
];
