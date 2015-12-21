BEGIN {
    print "[";
}

/^#/ {
  # Ignore log comment lines
}

/^[1-9][0-9]*/ {
    date = $1                         # date
    time = $2                         # time
    x_edge_location = $3              # x-edge-location
    sc_bytes = $4                     # sc-bytes
    c_ip = $5                         # c-ip
    cs_method = $6                    # cs-method
    cs_Host = $7                      # cs(Host)
    cs_uri_stem = $8                  # cs-uri-stem
    sc_status = $9                    # sc-status
    cs_Referer = $10                  # cs(Referer)
    cs_User_Agent = $11               # cs(User-Agent)
    cs_uri_query = $12                # cs-uri-query
    cs_Cookie = $13                   # cs(Cookie)
    x_edge_result_type = $14          # x-edge-result-type
    x_edge_request_id = $15           # x-edge-request-id
    x_host_header = $16               # x-host-header
    cs_protocol = $17                 # cs-protocol
    cs_bytes = $18                    # cs-bytes
    time_taken = $19                  # time-taken
    x_forwarded_for = $20             # x-forwarded-for
    ssl_protocol = $21                # ssl-protocol
    ssl_cipher = $22                  # ssl-cipher
    x_edge_response_result_type = $23 # x-edge-response-result-type
    printf "{\n\t\"date\": \"%s\",\n\t\"time\":\"%s\",\n\t\"x-edge-location\":\"\%s\",\n\t\"sc-bytes\": \"%s\",\n\t\"c-ip\": \"%s\",\n\t\"cs-method\": \"%s\",\n\t\"cs(Host)\": \"%s\",\n\t\"cs-uri-stream\": \"%s\",\n\t\"sc-status\": \"%s\",\n\t\"cs(Referer)\": \"%s\",\n\t\"cs(User-Agent)\": \"%s\",\n\t\"cs-uri-query\": \"%s\",\n\t\"cs(Cookie)\": \"%s\",\n\t\"x-edge-result-type\": \"%s\",\n\t\"x-edge-request-id\": \"%s\",\n\t\"x-host-header\": \"%s\"\n\t\"cs-protocol\": \"%s\",\n\t\"cs-bytes\": \"%s\",\n\t\"time-taken\": \"%s\",\n\t\"x-forwarded-for\": \"%s\",\n\t\"ssl-protocol\": \"%s\",\n\t\"ssl-cipher\": \"%s\",\n\t\"x-edge-response-result-type\": \"%s\"\n},\n", date, time, x_edge_location, sc_bytes, c_ip, cs_method, cs_Host, cs_uri_stem, sc_status, cs_Referer, cs_User_Agent, cs_uri_query, cs_Cookie, x_edge_result_type, x_edge_request_id, x_host_header, cs_protocol, cs_bytes, time_taken, x_forwarded_for, ssl_protocol, ssl_cipher, x_edge_response_result_type
}

END {
  print "]";
}
