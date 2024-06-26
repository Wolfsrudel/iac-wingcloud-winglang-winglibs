bring "./workload.w" as containers;
bring expect;
bring http;

let echo = new containers.Workload(
  name: "http-echo",
  image: "hashicorp/http-echo",
  port: 5678,
  public: true,
  replicas: 2,
  args: ["-text=hello1234"],
) as "http-echo";

let httpGet = inflight (url: str?): str => {
  if let url = url {
    return http.get(url).body;
  }

  throw "no body";
};

test "access public url" {
  let echoBody = httpGet(echo.publicUrl);
  assert(echoBody.contains("hello1234"));
}
