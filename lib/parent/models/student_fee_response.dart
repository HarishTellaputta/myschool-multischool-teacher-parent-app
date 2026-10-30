
class StudentFeeResponse {
  final int id;
  final int studentId;
  final int? feeStructureId;
  final String? studentName;
  final String? feeName;
  final String? status;

  final double totalAmount;
  final double paidAmount;
  final double pendingAmount;

  // Discount details
  final String? discountType;
  final double discountValue;
  final double discountAmount;
  final String? discountReason;

  // Amount after discount
  final double payableAmount;

  final DateTime? dueDate;

  StudentFeeResponse({
    required this.id,
    required this.studentId,
    this.feeStructureId,
    this.studentName,
    this.feeName,
    this.status,
    required this.totalAmount,
    required this.paidAmount,
    required this.pendingAmount,
    this.discountType,
    required this.discountValue,
    required this.discountAmount,
    this.discountReason,
    required this.payableAmount,
    this.dueDate,
  });

  factory StudentFeeResponse.fromJson(Map<String, dynamic> json) {
    return StudentFeeResponse(
      id: json['id'] ?? 0,
      studentId: json['studentId'] ?? 0,
      feeStructureId: json['feeStructureId'],
      studentName: json['studentName'],
      feeName: json['feeName'],
      status: json['status'],

      totalAmount: _toDouble(json['totalAmount']),
      paidAmount: _toDouble(json['paidAmount']),
      pendingAmount: _toDouble(json['pendingAmount']),

      discountType: json['discountType'],
      discountValue: _toDouble(json['discountValue']),
      discountAmount: _toDouble(json['discountAmount']),
      discountReason: json['discountReason'],

      payableAmount: json['payableAmount'] != null
          ? _toDouble(json['payableAmount'])
          : (_toDouble(json['totalAmount']) -
                  _toDouble(json['discountAmount']))
              .clamp(0.0, double.infinity)
              .toDouble(),

      dueDate: json['dueDate'] != null
          ? DateTime.tryParse(json['dueDate'].toString())
          : null,
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString()) ?? 0.0;
  }
}
