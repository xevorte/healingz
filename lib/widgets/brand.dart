import 'package:flutter/material.dart';

import '../models/destination.dart';

class Brand extends StatelessWidget {
  const Brand({super.key, this.light = false});
  final bool light;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: const Color(0xff2f8f73),
          borderRadius: BorderRadius.circular(11),
        ),
        child: const Icon(Icons.spa, color: Colors.white),
      ),
      const SizedBox(width: 10),
      Text(
        'healingz',
        style: TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.w800,
          color: light ? Colors.white : const Color(0xff203d33),
        ),
      ),
    ],
  );
}

class DestinationCard extends StatelessWidget {
  const DestinationCard({
    super.key,
    required this.place,
    required this.saved,
    required this.onSave,
    required this.onOpen,
  });
  final Destination place;
  final bool saved;
  final VoidCallback onSave;
  final VoidCallback onOpen;
  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onOpen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  place.image,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) => progress == null
                      ? child
                      : const ColoredBox(
                          color: Color(0xffe8f1ed),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xffdcece5),
                    child: const Icon(Icons.landscape),
                  ),
                  webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      onPressed: onSave,
                      icon: Icon(
                        saved ? Icons.bookmark : Icons.bookmark_border,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place.name,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                Text(
                  place.location,
                  style: const TextStyle(color: Color(0xff779087)),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
