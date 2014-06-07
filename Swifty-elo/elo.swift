//
//  elo.swift
//  Swifty-elo
//
//  Created by Andreas on 03/06/14.
//  Copyright (c) 2014 Andreas. All rights reserved.
//

import Cocoa

class Elo {
    
    var limit: (low: Double, high: Double) = (100, 1000000)
    
    var rating: Double {
        didSet {
            rating = max(limit.low, rating)
            rating = min(limit.high, rating)
        }
    }
    
    init(elo: Double) {
        rating = elo
    }
    
    func chance_to_win(other: Elo) -> Double {
        let diff = (other.rating - self.rating) / 400
        return 1 / (1 + pow(10, diff))
    }
    
    func battle(other: Elo, score: (Double, Double)) {
        let tot = score.0 + score.1
        let chance = self.chance_to_win(other)
        self.update_rating(score.0 - tot * chance)
        other.update_rating(score.1 - tot * (1 - chance))
    }
    
    func update_rating(distance_from_prediction: Double) {
        let k = change_speed()
        rating = rating + k * distance_from_prediction
    }
    
    func change_speed() -> Double {
        switch rating {
        case 0..2100:
            return 32
        case 2100..2400:
            return 24
        default:
            return 10
        }
    }
    
}

func it_predicts_draw() {
    let a = Elo(elo: 1500)
    let b = Elo(elo: 1500)
    let chance = a.chance_to_win(b)
    assert(chance == 0.5)
}

func law_of_total_probability() {
    let a = Elo(elo: 1500)
    let b = Elo(elo: 2500)
    let totchance = a.chance_to_win(b) + b.chance_to_win(a)
    assert(totchance == 1)
}

func draw_between_same_rated_players() {
    var a = Elo(elo: 1500)
    var b = Elo(elo: 1500)
    a.battle(b, score: (1, 1))
    assert(a.rating == b.rating)
}

func draw_between_diffrent_rated_players() {
    var a = Elo(elo: 100)
    var b = Elo(elo: 1500)
    a.battle(b, score: (1, 1))
    assert(a.rating > 100 && b.rating < 1500)
}

func cant_go_below_limit() {
    let a = Elo(elo: 100)
    a.update_rating(-100)
    assert(a.rating >= a.limit.low)
}

func cant_go_above_limit() {
    let a = Elo(elo: 1000000)
    a.update_rating(100)
    assert(a.rating <= a.limit.high)
}