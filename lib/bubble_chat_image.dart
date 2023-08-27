import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class BubbleChatImage extends StatelessWidget {
  final double bubbleRadius;
  final bool isSender;
  final Color color;
  final Color imageLoadCircleColor;
  final String text;
  final String imageUrl;
  final String? timeStampText;
  final bool tail;
  final bool sent;
  final bool delivered;
  final bool seen;
  final bool isVideoType;
  final String? videoUrl;

  ///A callback on the chat widget tap when the chat is video type
  final Function()? onPlayButtonTap;
  final TextStyle textStyle;
  final TextStyle timeStampStyle;

  const BubbleChatImage({
    Key? key,
    required this.text,
    required this.imageUrl,
    this.videoUrl,
    this.timeStampText,
    this.bubbleRadius = 16,
    this.isSender = true,
    this.color = Colors.white70,
    this.imageLoadCircleColor = Colors.white,
    this.tail = true,
    this.sent = false,
    this.delivered = false,
    this.seen = false,
    this.isVideoType = false,
    this.textStyle = const TextStyle(
      color: Colors.black87,
      fontSize: 16,
    ),
    this.timeStampStyle = const TextStyle(
      color: Color.fromRGBO(164, 169, 172, 1),
      fontSize: 12,
    ),
    this.onPlayButtonTap,
  }) : super(key: key);

  ///chat bubble builder method
  @override
  Widget build(BuildContext context) {
    bool stateTick = false;
    Icon? stateIcon;
    if (sent) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (delivered) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (seen) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF92DEDA),
      );
    }

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        child: Container(
          padding: const EdgeInsets.all(2),
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(bubbleRadius),
              topRight: Radius.circular(bubbleRadius),
              bottomLeft: Radius.circular(
                tail
                    ? isSender
                        ? bubbleRadius
                        : 0
                    : 16,
              ),
              bottomRight: Radius.circular(
                tail
                    ? isSender
                        ? 0
                        : bubbleRadius
                    : 16,
              ),
            ),
          ),
          child: Column(
            children: [
              Visibility(
                visible: imageUrl.isNotEmpty,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(bubbleRadius),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: GestureDetector(
                    onTap: () {
                      if (isVideoType) {
                        if (videoUrl == null) {
                          throw ("Video url not found");
                        } else if (onPlayButtonTap != null) {
                          onPlayButtonTap!.call();
                        }
                        return;
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return PhotoView(
                              imageProvider:
                                  CachedNetworkImageProvider(imageUrl),
                            );
                          },
                        );
                        return;
                      }
                    },
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(bubbleRadius),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Center(
                              child: CircularProgressIndicator(
                                value: downloadProgress.progress,
                                color: imageLoadCircleColor,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        Visibility(
                          visible: isVideoType,
                          child: const Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: CircleAvatar(
                                backgroundColor: Colors.black45,
                                radius: 25,
                                child: Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.end,
                children: <Widget>[
                  Visibility(
                    visible: text.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        text,
                        style: textStyle,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (timeStampText != null)
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            6,
                            text.isNotEmpty ? 0 : 6,
                            stateTick ? 2 : 6,
                            6,
                          ),
                          child: Text(
                            timeStampText!,
                            style: timeStampStyle,
                          ),
                        ),
                      if (stateIcon != null && stateTick)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(2, 6, 6, 6),
                          child: stateIcon,
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
