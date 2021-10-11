#!/usr/bin/env ruby

# frozen_string_literal: true

LAST_FRAME = 9

# スコアを読み取り、整数の配列に変換
scores = ARGV[0].split(',')

shot_count = 0
shots = []
scores.each do |score|
  if score == 'X' && (shot_count / 2 < LAST_FRAME)
    shots << 10
    shots << 0 # ストライクの場合は投球数が1なので2投目を0として追加
    shot_count += 2
  elsif score == 'X'
    shots << 10
    shot_count += 1
  else
    shots << score.to_i
    shot_count += 1
  end
end

# フレームごとに投球をまとめる
frames = []
shots.each_slice(2) do |shot|
  frames << shot
end

# 最終フレームだけ投球が3回になることがあるのでそのための処理
if frames[LAST_FRAME].sum >= 10
  frames[LAST_FRAME] << frames[LAST_FRAME + 1][0]
  frames.delete_at(LAST_FRAME + 1)
end

# スコア計算
total_score = 0
frames.each_with_index do |frame, index|
  if index == LAST_FRAME
    total_score += frame.sum
  elsif frame[0] == 10 # ストライクなら次の2投の点を加算
    total_score = if frames[index + 1][0] == 10 && index != LAST_FRAME - 1
                    total_score + frame.sum + frames[index + 1][0] + frames[index + 2][0]
                  else
                    total_score + frame.sum + frames[index + 1][0] + frames[index + 1][1]
                  end
  elsif frame.sum == 10 # スペアなら次の1投の点を加算
    total_score += (frame.sum + frames[index + 1][0])
  else
    total_score += frame.sum
  end
end

puts total_score
