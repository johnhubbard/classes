class packet;

    // Signals that will be sent to RTL:
    rand bit [7:0]  tx_buffer[1500];
    rand integer    pkt_length;

    // Signals that are just for the test framework (not for RTL):
    static bit [15:0] pktid;

    constraint legal_payload {
        pkt_length inside {[46:1500]};
    }

    function new();
        pktid++;
    endfunction

    function void print();
        $display("pktid=%0d, packet tx_buffer=%h",
                 pktid, tx_buffer);
    endfunction
endclass
