// This file contains the modules for the game logic and rendering of the game.

module m_clear_screen(clock, resetn, enable, finished);

    // basic inputs
    input clock, resetn, enable;
    // finish signal
    output reg finished;

    always @ (posedge clock) begin
        if (!resetn)
            finished <= 0;  // Reset to initial state
        else if (enable)
            finished <= 1;  // Finish immediately when enabled, for testing
    end

endmodule

module m_update_position(clock, resetn, enable, finished);

    // basic inputs
    input clock, resetn, enable;
    // finish signal
    output reg finished;

    always @ (posedge clock) begin
        if (!resetn)
            finished <= 0;  // Reset to initial state
        else if (enable)
            finished <= 1;  // Finish immediately when enabled, for testing
    end

endmodule

module m_eat_food(clock, resetn, enable, finished);

    // basic inputs
    input clock, resetn, enable;
    // finish signal
    output reg finished;

    always @ (posedge clock) begin
        if (!resetn)
            finished <= 0;  // Reset to initial state
        else if (enable)
            finished <= 1;  // Finish immediately when enabled, for testing
    end

endmodule

module m_update_ghost_directions(clock, resetn, enable, finished);

    // basic inputs
    input clock, resetn, enable;
    // finish signal
    output reg finished;

    always @ (posedge clock) begin
        if (!resetn)
            finished <= 0;  // Reset to initial state
        else if (enable)
            finished <= 1;  // Finish immediately when enabled, for testing
    end

endmodule

module m_update_ghost_positions(clock, resetn, enable, finished);

    // basic inputs
    input clock, resetn, enable;
    // finish signal
    output reg finished;

    always @ (posedge clock) begin
        if (!resetn)
            finished <= 0;  // Reset to initial state
        else if (enable)
            finished <= 1;  // Finish immediately when enabled, for testing
    end

endmodule

module m_fill_screen(clock, resetn, enable, finished);

    // basic inputs
    input clock, resetn, enable;
    // finish signal
    output reg finished;

    always @ (posedge clock) begin
        if (!resetn)
            finished <= 0;  // Reset to initial state
        else if (enable)
            finished <= 1;  // Finish immediately when enabled, for testing
    end

endmodule

module m_render_blocks(clock, resetn, enable, finished);

    // basic inputs
    input clock, resetn, enable;
    // finish signal
    output reg finished;

    always @ (posedge clock) begin
        if (!resetn)
            finished <= 0;  // Reset to initial state
        else if (enable)
            finished <= 1;  // Finish immediately when enabled, for testing
    end

endmodule

module m_render_player(clock, resetn, enable, finished);

    // basic inputs
    input clock, resetn, enable;
    // finish signal
    output reg finished;

    always @ (posedge clock) begin
        if (!resetn)
            finished <= 0;  // Reset to initial state
        else if (enable)
            finished <= 1;  // Finish immediately when enabled, for testing
    end

endmodule

module m_render_food(clock, resetn, enable, finished);

    // basic inputs
    input clock, resetn, enable;
    // finish signal
    output reg finished;

    always @ (posedge clock) begin
        if (!resetn)
            finished <= 0;  // Reset to initial state
        else if (enable)
            finished <= 1;  // Finish immediately when enabled, for testing
    end

endmodule

module m_render_ghosts(clock, resetn, enable, finished);

    // basic inputs
    input clock, resetn, enable;
    // finish signal
    output reg finished;

    always @ (posedge clock) begin
        if (!resetn)
            finished <= 0;  // Reset to initial state
        else if (enable)
            finished <= 1;  // Finish immediately when enabled, for testing
    end

endmodule

module m_ghost_collision(clock, resetn, enable, finished);

    // basic inputs
    input clock, resetn, enable;
    // finish signal
    output reg finished;

    always @ (posedge clock) begin
        if (!resetn)
            finished <= 0;  // Reset to initial state
        else if (enable)
            finished <= 1;  // Finish immediately when enabled, for testing
    end

endmodule