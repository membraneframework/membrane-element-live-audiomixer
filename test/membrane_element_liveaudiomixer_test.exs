defmodule Membrane.Element.LiveAudioMixer.Test do
  use ExUnit.Case, async: true

  alias Membrane.Time
  alias Membrane.Caps.Audio.Raw, as: Caps

  @module Membrane.Element.LiveAudioMixer.Source

  @interval 1 |> Time.second()
  @delay 500 |> Time.milliseconds()
  @caps %Caps{sample_rate: 48_000, format: :s16le, channels: 2}

  @default_options %{
    interval: @interval,
    delay: @delay,
    caps: @caps
  }

  @empty_state %{
    interval: @interval,
    delay: @delay,
    caps: @caps,
    sinks: %{},
    interval_start_time: nil,
    expected_tick_duration: nil,
    timer_ref: nil,
    playing: false
  }

  @dummy_state %{
    @empty_state
    | sinks: %{
        :sink_1 => :dummy_sink_1,
        :sink_2 => :dummy_sink_2,
        :sink_3 => :dummy_sink_3
      },
      interval_start_time: 123,
      expected_tick_duration: @interval,
      timer_ref: :mtimer,
      playing: true
  }

  test "handle_init/1 should create an empty state" do
    assert {:ok, state} = @module.handle_init(@default_options)
    assert @empty_state = state
    assert state.playing == false
  end

  describe "handle_play should" do
    test "set playing to true" do
      assert {{:ok, _actions}, %{playing: true}} = @module.handle_play(@dummy_state)
    end
  end
end
