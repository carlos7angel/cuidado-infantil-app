class EvidenceFile {
  final String? type;
  final String? id;
  final String? uniqueCode;
  final String? name;
  final String? originalName;
  final String? description;
  final String? mimeType;
  final int? size;
  final String? humanReadableSize;
  final String? url;
  final String? path;
  final String? extension;
  final bool isImage;
  final bool isDocument;
  final String? typeCategory;
  final String? createdAt;
  final String? updatedAt;

  EvidenceFile({
    this.type,
    this.id,
    this.uniqueCode,
    this.name,
    this.originalName,
    this.description,
    this.mimeType,
    this.size,
    this.humanReadableSize,
    this.url,
    this.path,
    this.extension,
    this.isImage = false,
    this.isDocument = false,
    this.typeCategory,
    this.createdAt,
    this.updatedAt,
  });

  factory EvidenceFile.fromJson(Map<String, dynamic> json) {
    return EvidenceFile(
      type: json['type']?.toString(),
      id: json['id']?.toString(),
      uniqueCode: json['unique_code']?.toString(),
      name: json['name']?.toString(),
      originalName: json['original_name']?.toString(),
      description: json['description']?.toString(),
      mimeType: json['mime_type']?.toString(),
      size: json['size'] is int 
          ? json['size'] 
          : (json['size'] != null ? int.tryParse(json['size'].toString()) : null),
      humanReadableSize: json['human_readable_size']?.toString(),
      url: json['url']?.toString(),
      path: json['path']?.toString(),
      extension: json['extension']?.toString(),
      isImage: json['is_image'] == true,
      isDocument: json['is_document'] == true,
      typeCategory: json['type_category']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'id': id,
      'unique_code': uniqueCode,
      'name': name,
      'original_name': originalName,
      'description': description,
      'mime_type': mimeType,
      'size': size,
      'human_readable_size': humanReadableSize,
      'url': url,
      'path': path,
      'extension': extension,
      'is_image': isImage,
      'is_document': isDocument,
      'type_category': typeCategory,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

