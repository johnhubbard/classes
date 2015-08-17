class monitor;

    mailbox                  m_mon2sb;
    virtual switch_interface m_mi;

    function new(input virtual switch_interface mif,
                 input mailbox mon2sb);
        m_mi = mif;
        m_mon2sb = mon2sb;
        m_mi.cb.pkt_rx_ren <= 1'b0;
    endfunction

    task collect_packet(integer expected_packet_id);
        bit done;
        integer byte_index;
        packet rcv_packet;
        rcv_packet = new(expected_packet_id);

        done = 0;
        byte_index = 0;

        // Wait for the device to indicate that a packet has arrived:
        while(!m_mi.cb.pkt_rx_avail)
            @(posedge m_mi.clk);

        m_mi.cb.pkt_rx_ren <= 1'b1;
        @(posedge m_mi.clk);

        while (!done) begin
            if (m_mi.cb.pkt_rx_val) begin

                rcv_packet.tx_buffer[byte_index] <= m_mi.cb.pkt_rx_data;
                byte_index++;

                if (m_mi.cb.pkt_rx_eop) begin
                    done = 1'b1;
                    m_mi.cb.pkt_rx_ren <= 1'b0;
                end

            end

            @(posedge m_mi.clk);
        end

        rcv_packet.pkt_length = byte_index;

        // Send the packet to the scoreboard, and also print it:
        m_mon2sb.put(rcv_packet);
        rcv_packet.print("Received");

    endtask
endclass

