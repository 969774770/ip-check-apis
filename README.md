# IP Check APIs

精选 **129 个**公开的「查询访问者出口 IP」API，全部经过真实环境实测验证。

> **验证方式**：`curl -sL`（超时 12s）走真实代理链路请求，严格判据为 **HTTP 200 且响应中返回的 IP 与已知真实出口 IP 完全一致** —— 这条判据能剔除「返回占位符 IP」「返回自身服务器 IP」「返回 DNS 解析器 IP」等常见假阳性。
>
> **验证日期**：2026-09-24 · 共 158 个候选，最终收录 129 个，淘汰 28 个（见文末）

## 快速开始

```bash
# 只要一个纯文本 IP（最省事）
curl -s https://icanhazip.com

# 简单 JSON
curl -s https://api.ipify.org?format=json

# 富 JSON（含归属地 / ASN / ISP）
curl -s https://ipinfo.io/json

# Cloudflare 官方（含机房代码 colo）
curl -s https://1.1.1.1/cdn-cgi/trace | grep ^ip=

# 中文结果
curl -s https://myip.ipip.net
```

## 常用首选（按场景）

| 场景 | 推荐 | 理由 |
|------|------|------|
| 脚本里只要 IP | `https://icanhazip.com` | 纯文本，零解析成本，多年稳定 |
| AWS 环境 / 要极稳 | `https://checkip.amazonaws.com` | AWS 官方，几乎不会挂 |
| 要归属地 | `https://ipinfo.io/json` | 字段规范，社区事实标准 |
| 要字段最全 | `https://ipwho.is/` | 国家/城市/ASN/ISP/时区/经纬度全都有 |
| 要判断「是不是代理/VPN」 | `https://proxycheck.io/v2/`<br>`https://am.i.mullvad.net/json` | 前者 proxy 判定，后者 Mullvad 出口 + 黑名单 |
| 要判断「是否 Tor 出口」 | `https://check.torproject.org/api/ip` | 官方接口，返回 `IsTor` |
| 要机房位置 | `https://1.1.1.1/cdn-cgi/trace` | 返回 `colo=XXX` 机场三字码 |
| 无 DNS 环境 / 最轻量 | `https://1.1.1.1/cdn-cgi/trace` | 直接用 IP 访问，无需域名解析 |
| 国内宽带真实 IP | `https://myip.ipip.net`<br>`https://whois.pconline.com.cn/ipJson.jsp?json=true` | 🇨🇳 走国内线路时返回真实本地 IP |

> **小技巧**：判断代理/分流是否生效时，同时请求一个境外接口和一个 🇨🇳 国内接口 —— 两者返回不同 IP 才说明国内外分流正常工作。

## Full list

**129** endpoints, all verified: HTTP 200 and the returned IP matched the known real egress IP.

### 响应体直接就是 IP 字符串  /  plain text (body IS the IP)  (48)

| # | URL | IP field | Note |
|---|-----|----------|------|
| 1 | https://icanhazip.com | - |  |
| 2 | https://ipv4.icanhazip.com | - |  |
| 3 | https://www.icanhazip.com | - |  |
| 4 | http://icanhazip.com | - |  |
| 5 | https://ipecho.net/plain | - |  |
| 6 | http://ipecho.net/plain | - |  |
| 7 | https://ident.me | - |  |
| 8 | https://v4.ident.me | - |  |
| 9 | https://checkip.amazonaws.com | - |  |
| 10 | https://ifconfig.me/ip | - |  |
| 11 | https://ifconfig.me/all | - | key: value 文本，ip_addr 行 |
| 12 | http://ifconfig.me/ip | - |  |
| 13 | https://ifconfig.co/ip | - |  |
| 14 | https://ifconfig.io/ip | - |  |
| 15 | https://ifconfig.es | - |  |
| 16 | https://api.ipify.org | - |  |
| 17 | https://api.ipify.org/?format=text | - |  |
| 18 | https://api4.ipify.org | - |  |
| 19 | https://api64.ipify.org | - |  |
| 20 | https://api.ip.sb/ip | - |  |
| 21 | https://api-ipv4.ip.sb/ip | - |  |
| 22 | https://ipinfo.io/ip | - |  |
| 23 | http://ipinfo.io/ip | - |  |
| 24 | https://api.ipquery.io/ | - |  |
| 25 | https://api.techniknews.net/ip | - |  |
| 26 | https://am.i.mullvad.net/ip | - |  |
| 27 | https://wtfismyip.com/text | - |  |
| 28 | https://ipv4.wtfismyip.com/text | - |  |
| 29 | https://ipaddress.sh | - |  |
| 30 | https://ip.tyk.nu | - |  |
| 31 | https://ipconfig.io/ip | - |  |
| 32 | https://ipapi.co/ip/ | - |  |
| 33 | https://check-host.net/ip | - |  |
| 34 | https://curlmyip.net | - |  |
| 35 | https://echoip.de | - |  |
| 36 | https://l2.io/ip | - |  |
| 37 | https://myexternalip.com/raw | - |  |
| 38 | https://myip.addr.tools | - |  |
| 39 | https://nsupdate.info/myip | - |  |
| 40 | https://whatismyip.akamai.com | - |  |
| 41 | https://ip.anysrc.net/plain | - |  |
| 42 | https://ip.changeip.com | - | 正文 + HTML 注释双份 |
| 43 | https://freedns.afraid.org/dynamic/check.php | - | Detected IP : x.x.x.x |
| 44 | https://www.trackip.net/ip | - |  |
| 45 | http://ip-api.com/line/?fields=query | - |  |
| 46 | https://ip.3322.net | - | 🇨🇳 local ISP egress |
| 47 | https://myip.ipip.net | - | 🇨🇳 local ISP egress |
| 48 | https://ddns.oray.com/checkip | - | 🇨🇳 local ISP egress |

### JSON，含明确的 IP 字段  /  JSON (explicit IP field)  (48)

| # | URL | IP field | Note |
|---|-----|----------|------|
| 1 | https://ifconfig.me/all.json | `ip_addr` |  |
| 2 | https://ifconfig.co/json | `ip` |  |
| 3 | https://ifconfig.io/all.json | `forwarded` | 同域多请求易触发限流 |
| 4 | https://ifconfig.es/json | `ip` |  |
| 5 | https://api.ipify.org?format=json | `ip` |  |
| 6 | https://api4.ipify.org?format=json | `ip` |  |
| 7 | https://api64.ipify.org?format=json | `ip` |  |
| 8 | https://api.ip.sb/jsonip | `ip` |  |
| 9 | https://api.ip.sb/geoip | `ip` |  |
| 10 | https://api-ipv4.ip.sb/geoip | `ip` |  |
| 11 | https://jsonip.com | `ip` |  |
| 12 | https://api.country.is | `ip` |  |
| 13 | https://api.iplocation.net/?cmd=get-ip | `ip` |  |
| 14 | https://check.torproject.org/api/ip | `IP` | 附带 IsTor 判断 |
| 15 | https://ipinfo.io/json | `ip` | hostname/城市/运营商/时区 |
| 16 | https://ipwho.is/ | `ip` | 字段最全 |
| 17 | https://ipwhois.app/json | `ip` |  |
| 18 | https://get.geojs.io/v1/ip.json | `ip` |  |
| 19 | https://get.geojs.io/v1/ip/country.json | `ip` |  |
| 20 | https://get.geojs.io/v1/ip/geo.json | `ip` | 精度较好 |
| 21 | https://ipleak.net/json/ | `ip` |  |
| 22 | https://ipv4.ipleak.net/json/ | `ip` |  |
| 23 | https://api.ipquery.io/?format=json | `ip` |  |
| 24 | https://api.ipapi.is | `ip` | 含 ASN / 是否代理 |
| 25 | https://api.ip2location.io/ | `ip` |  |
| 26 | https://api.seeip.org/jsonip | `ip` |  |
| 27 | https://freegeoip.app/json/ | `ip` |  |
| 28 | https://freeipapi.com/api/json | `ipAddress` | 需跟随 307 重定向 |
| 29 | https://json.geoiplookup.io | `ip` |  |
| 30 | https://api.bigdatacloud.net/data/client-info | `ipString` | 附带设备/OS 识别 |
| 31 | https://ip.addr.tools | `ip` |  |
| 32 | https://ip.guide | `ip` | 含 CIDR / ASN 详情 |
| 33 | https://proxycheck.io/v2/ | - | IP 作为顶层动态 key，含 proxy 判定 |
| 34 | https://am.i.mullvad.net/json | `ip` | 含 Mullvad 出口 / 黑名单判定 |
| 35 | https://wtfismyip.com/json | `YourFuckingIPAddress` |  |
| 36 | https://ipv4.wtfismyip.com/json | `YourFuckingIPAddress` |  |
| 37 | https://httpbin.org/ip | `origin` |  |
| 38 | https://httpbingo.org/ip | `origin` |  |
| 39 | https://echo.free.beeceptor.com | `ip` |  |
| 40 | https://echo.hoppscotch.io | `headers.x-nf-client-connection-ip` |  |
| 41 | https://echo.zuplo.io | `headers.true-client-ip` |  |
| 42 | https://reallyfreegeoip.org/json/ | `ip` | 代理分流规则命中探针 |
| 43 | https://myip.wtf/json | `YourFuckingIPAddress` |  |
| 44 | https://ipconfig.io/json | `ip` |  |
| 45 | https://www.trackip.net/ip?json | `IP` |  |
| 46 | http://ip-api.com/json/ | `query` | 免费版仅 http，https 返回 403 |
| 47 | https://myip.ipip.net/json | `data.ip` | 🇨🇳 local ISP egress |
| 48 | https://whois.pconline.com.cn/ipJson.jsp?json=true | `ip` | 🇨🇳 local ISP egress |

### Cloudflare cdn-cgi/trace，key=value 文本，IP 在 ip= 行  /  Cloudflare cdn-cgi/trace (key=value, IP on the ip= line)  (10)

| # | URL | IP field | Note |
|---|-----|----------|------|
| 1 | http://www.cloudflare.com/cdn-cgi/trace | - |  |
| 2 | https://www.cloudflare.com/cdn-cgi/trace | - |  |
| 3 | https://cloudflare.com/cdn-cgi/trace | - |  |
| 4 | https://cp.cloudflare.com/cdn-cgi/trace | - |  |
| 5 | https://1.1.1.1/cdn-cgi/trace | - | 含 colo 机房代码 |
| 6 | https://1.0.0.1/cdn-cgi/trace | - |  |
| 7 | https://one.one.one.one/cdn-cgi/trace | - |  |
| 8 | https://speed.cloudflare.com/cdn-cgi/trace | - |  |
| 9 | https://cdn.jsdelivr.net/cdn-cgi/trace | - |  |
| 10 | https://cdnjs.cloudflare.com/cdn-cgi/trace | - |  |

### HTML 页面，IP 嵌在正文/标题中，需正则提取  /  HTML page (IP embedded, needs regex extraction)  (14)

| # | URL | IP field | Note |
|---|-----|----------|------|
| 1 | https://ifconfig.me | - |  |
| 2 | https://ifconfig.io | - | 同域多请求易触发限流 |
| 3 | https://ifconfig.pro | - | IP 在 title 中 |
| 4 | https://ifconfig.icu | - |  |
| 5 | https://ip.me | - |  |
| 6 | https://ip.wtf | - |  |
| 7 | https://myip.wtf | - |  |
| 8 | https://ip4.me | - |  |
| 9 | https://ipconfig.io | - |  |
| 10 | https://ip.lafibre.info | - |  |
| 11 | https://checkip.dyndns.com | - | 正文 Current IP Address: x.x.x.x |
| 12 | http://monip.org | - |  |
| 13 | https://browserleaks.com/ip | - |  |
| 14 | https://cip.cc | - | 🇨🇳 local ISP egress |

### XML 格式  /  XML  (3)

| # | URL | IP field | Note |
|---|-----|----------|------|
| 1 | https://api.ipify.org?format=xml | - |  |
| 2 | https://ipwhois.app/xml/ | - |  |
| 3 | https://api.ipquery.io/?format=xml | - |  |

### YAML 格式  /  YAML  (2)

| # | URL | IP field | Note |
|---|-----|----------|------|
| 1 | https://api.ipquery.io/?format=yaml | - |  |
| 2 | https://ipapi.co/yaml/ | - |  |

### CSV 格式  /  CSV  (2)

| # | URL | IP field | Note |
|---|-----|----------|------|
| 1 | https://ipwhois.app/csv/ | - |  |
| 2 | https://ip4.me/api/ | - | IPv4,<ip>,v1.1 |

### JSONP 回调包装  /  JSONP  (2)

| # | URL | IP field | Note |
|---|-----|----------|------|
| 1 | https://api.ipify.org?format=jsonp&callback=cb | - |  |
| 2 | https://ipv4.test-ipv6.com/ip/ | - | 回调包裹，内含 ip 字段 |

## 结构化数据

机器可读清单见 [apis.json](apis.json)，含每个接口的 `group`（响应格式）、`field`（IP 所在字段）、`region`（是否中国大陆服务）以及淘汰名单。

## 自动体检

仓库自带体检脚本，随时复验这 129 个接口的可用性：

```powershell
# Windows PowerShell —— 检查全部
./scripts/check-apis.ps1

# 只检查某一类响应格式
./scripts/check-apis.ps1 -Group json

# 严格模式：要求响应中必须出现你自己的真实出口 IP（推荐，可排除假阳性）
./scripts/check-apis.ps1 -Expected 203.0.113.7

# 调整超时（默认 12 秒）
./scripts/check-apis.ps1 -TimeoutSec 20
```

```bash
# Linux / macOS
bash scripts/check-apis.sh
```

输出示例：

```
IP Check APIs health check  2026-09-24 13:55:24
source: D:\AI\ip-check-apis\scripts\..\apis.json
mode: strict (expect 203.0.113.7)   endpoints: 3
------------------------------------------------------------------------------
  1 [OK] 200  ip=203.0.113.7       https://api.ipify.org?format=xml
  2 [OK] 200  ip=203.0.113.7       https://ipwhois.app/xml/
  3 [OK] 200  ip=203.0.113.7       https://api.ipquery.io/?format=xml
------------------------------------------------------------------------------
SUMMARY: 3 / 3 OK
```

> - 默认判据：HTTP 200 且响应体中出现合法 IPv4。这只能证明「接口活着」，**不能排除返回占位符 IP 的接口**。
> - `-Expected <你的真实出口 IP>` 才是严格判据：要求响应体必须包含该 IP。建议实际使用时用严格模式。
> - 依赖 `curl.exe`（Windows 10 1803+ 自带），缺失时脚本会明确报错。
> - 部分站点对同一来源的高频请求会限流（例如连续请求 `ifconfig.io` 的 3 个端点），单次批量体检中偶发失败属正常，隔一会儿重试即可。

## 已淘汰名单（28 个，实测不过关，避免踩坑）

| URL | Reason |
|-----|--------|
| https://ipapi.co/json/ | Cloudflare 403 challenge (改用 ipapi.co/ip/ 正常) |
| https://ip-api.com/json/ | 恒定 403，免费版仅支持 http (改用 http://ip-api.com/json/) |
| http://checkip.dyndns.org | 恒定无响应 (改用 https://checkip.dyndns.com 正常) |
| https://api.myip.com | connection failed |
| https://ip.useragentinfo.com/json | connection failed |
| https://qifu-api.baidubce.com/ip/local/geo/v1/district | 404 |
| https://api.vore.top/api/IPdata | server error (Redis MISCONF) |
| https://api.db-ip.com/v2/free/self | HTTP 200 但返回 OVER_QUERY_LIMIT，日限额已超 |
| https://httpbin.org/get | 无独立 IP 字段，IP 仅藏在 X-Amzn-Trace-Id 中，不可靠 |
| https://ip.tl | false positive，返回占位符 8.8.8.8 |
| https://scamalytics.com/ip | false positive，返回自身服务器 IP |
| https://edns.ip-api.com/json | 返回的是 DNS 解析器 IP，非访问者 IP |
| https://ip2country.info | false positive，返回示例 5.6.7.8 |
| https://whoami.akamai.net | DNS 查询接口，非 HTTP API，实测不通 |
| https://api.myip.ms | 限流 429 |
| https://demo.ip-api.com/json/ | 仅为演示页 |
| https://geoip-db.com/json | HTTPS 证书/连接失败 |
| https://api.extreme-ip-lookup.com/json | 需 API Key (401) |
| https://api.smart-ip.net/geoip-json | 需 API Key / 不可用 |
| https://www.geoplugin.net/json.gp | 连接失败 |
| https://ip-api.io/json | 需 API Key |
| https://ip.wf | 不可用 |
| https://4.ipw.cn | 境外不可达 |
| https://ip.ping0.cc/ip | 境外不可达 |
| https://ip1.dynupdate.no-ip.com | 不可用 |
| https://myip.dnsomatic.com | 限流 429 |
| https://ip-fast.com/api/ip/?format=json | 302 重定向且无内容 |
| https://api.my-ip.io/v2/ip.json | 不稳定（多轮中一轮超时） |

## 说明

- 本清单只收录**无需注册、无需 API Key** 的公开接口。
- 各站点均有自己的速率限制与配额，请勿高频轮询；生产环境建议本地缓存结果。
- 免费接口的归属地精度不保证，金融级场景请使用付费地理 IP 服务。
- 标记为 HTML 的接口需要正则提取 IP，稳定性通常不如纯文本/JSON 接口，非必要优先选前两类。
- 部分站点基于 Cloudflare 等 CDN，可能对自动化请求弹出人机验证（返回 403 挑战页），遇到时换一个接口重试即可。
- 欢迎提交 PR 补充新接口：请附上你的实测输出（响应示例 + 验证日期）。

## License

[MIT](LICENSE)
