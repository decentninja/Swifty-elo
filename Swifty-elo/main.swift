//
//  main.swift
//  Swifty-elo
//
//  Created by Andreas on 03/06/14.
//  Copyright (c) 2014 Andreas. All rights reserved.
//


let tests = [it_predicts_draw, law_of_total_probability, draw_between_same_rated_players, draw_between_diffrent_rated_players, cant_go_below_limit, cant_go_above_limit]
for test in tests {
    print(".")
    test()
}
println("ok")