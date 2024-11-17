class DashboardStats {
  final int totalCars;
  final int ongoingRentals;
  final double totalRevenue;
  final int pendingIssues;

  DashboardStats({
    required this.totalCars,
    required this.ongoingRentals,
    required this.totalRevenue,
    required this.pendingIssues,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalCars: json['totalCars'],
      ongoingRentals: json['ongoingRentals'],
      totalRevenue: json['totalRevenue'],
      pendingIssues: json['pendingIssues'],
    );
  }
}
