class PaginationInfo {
  final int total;
  final int count;
  final int perPage;
  final int currentPage;
  final int totalPages;
  final Map<String, dynamic>? links;

  PaginationInfo({
    required this.total,
    required this.count,
    required this.perPage,
    required this.currentPage,
    required this.totalPages,
    this.links,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      total: json['total'] is int 
          ? json['total'] 
          : (json['total'] != null ? int.tryParse(json['total'].toString()) ?? 0 : 0),
      count: json['count'] is int 
          ? json['count'] 
          : (json['count'] != null ? int.tryParse(json['count'].toString()) ?? 0 : 0),
      perPage: json['per_page'] is int 
          ? json['per_page'] 
          : (json['per_page'] != null ? int.tryParse(json['per_page'].toString()) ?? 10 : 10),
      currentPage: json['current_page'] is int 
          ? json['current_page'] 
          : (json['current_page'] != null ? int.tryParse(json['current_page'].toString()) ?? 1 : 1),
      totalPages: json['total_pages'] is int 
          ? json['total_pages'] 
          : (json['total_pages'] != null ? int.tryParse(json['total_pages'].toString()) ?? 1 : 1),
      links: json['links'] is Map ? json['links'] as Map<String, dynamic>? : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'count': count,
      'per_page': perPage,
      'current_page': currentPage,
      'total_pages': totalPages,
      'links': links,
    };
  }

  bool get hasMore => currentPage < totalPages;
}

