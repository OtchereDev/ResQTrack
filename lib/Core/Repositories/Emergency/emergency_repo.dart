abstract class EmergencyRepository{
   Future<dynamic> uploadEmergencyPhoto(context, dynamic data);
   Future<dynamic> createReport(context, dynamic data);
   Future<dynamic> getReport(context);
   Future<dynamic> getReportById(context, dynamic data);
}