// Autogenerated from Pigeon (v1.0.1), do not edit directly.
// See also: https://pub.dev/packages/pigeon

package ru.kodazm.cleaner.pigeons.junk;

import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MessageCodec;
import io.flutter.plugin.common.StandardMessageCodec;
import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

/** Generated class from Pigeon. */
@SuppressWarnings({"unused", "unchecked", "CodeBlock2Expr", "RedundantSuppression"})
public class Search {

  /** Generated class from Pigeon that represents data sent in messages. */
  public static class SearchResponse {
    private Long size;
    public Long getSize() { return size; }
    public void setSize(Long setterArg) { this.size = setterArg; }

    private List<Object> items;
    public List<Object> getItems() { return items; }
    public void setItems(List<Object> setterArg) { this.items = setterArg; }

    Map<String, Object> toMap() {
      Map<String, Object> toMapResult = new HashMap<>();
      toMapResult.put("size", size);
      toMapResult.put("items", items);
      return toMapResult;
    }
    static SearchResponse fromMap(Map<String, Object> map) {
      SearchResponse fromMapResult = new SearchResponse();
      Object size = map.get("size");
      fromMapResult.size = (size == null) ? null : ((size instanceof Integer) ? (Integer)size : (Long)size);
      Object items = map.get("items");
      fromMapResult.items = (List<Object>)items;
      return fromMapResult;
    }
  }

  public interface Result<T> {
    void success(T result);
  }
  private static class JunkSearchCodec extends StandardMessageCodec {
    public static final JunkSearchCodec INSTANCE = new JunkSearchCodec();
    private JunkSearchCodec() {}
    @Override
    protected Object readValueOfType(byte type, ByteBuffer buffer) {
      switch (type) {
        case (byte)128:         
          return SearchResponse.fromMap((Map<String, Object>) readValue(buffer));
        
        default:        
          return super.readValueOfType(type, buffer);
        
      }
    }
    @Override
    protected void writeValue(ByteArrayOutputStream stream, Object value)     {
      if (value instanceof SearchResponse) {
        stream.write(128);
        writeValue(stream, ((SearchResponse) value).toMap());
      } else 
{
        super.writeValue(stream, value);
      }
    }
  }

  /** Generated interface from Pigeon that represents a handler of messages from Flutter.*/
  public interface JunkSearch {
    void getApkFiles(Result<SearchResponse> result);
    void getDownloadFiles(Result<SearchResponse> result);
    void getCacheFiles(Result<SearchResponse> result);
    void getLargeFiles(Result<SearchResponse> result);

    /** The codec used by JunkSearch. */
    static MessageCodec<Object> getCodec() {
      return JunkSearchCodec.INSTANCE;
    }

    /** Sets up an instance of `JunkSearch` to handle messages through the `binaryMessenger`. */
    static void setup(BinaryMessenger binaryMessenger, JunkSearch api) {
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.JunkSearch.getApkFiles", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              api.getApkFiles(result -> { wrapped.put("result", result); reply.reply(wrapped); });
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
              reply.reply(wrapped);
            }
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.JunkSearch.getDownloadFiles", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              api.getDownloadFiles(result -> { wrapped.put("result", result); reply.reply(wrapped); });
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
              reply.reply(wrapped);
            }
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.JunkSearch.getCacheFiles", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              api.getCacheFiles(result -> { wrapped.put("result", result); reply.reply(wrapped); });
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
              reply.reply(wrapped);
            }
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.JunkSearch.getLargeFiles", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              api.getLargeFiles(result -> { wrapped.put("result", result); reply.reply(wrapped); });
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
              reply.reply(wrapped);
            }
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
    }
  }
  private static Map<String, Object> wrapError(Throwable exception) {
    Map<String, Object> errorMap = new HashMap<>();
    errorMap.put("message", exception.toString());
    errorMap.put("code", exception.getClass().getSimpleName());
    errorMap.put("details", null);
    return errorMap;
  }
}
