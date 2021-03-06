/*PGR-GNU*****************************************************************
File: vrp_vroom_problem.hpp

Copyright (c) 2021 pgRouting developers
Mail: project@pgrouting.org

Function's developer:
Copyright (c) 2021 Ashish Kumar
Mail: ashishkr23438@gmail.com
------

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

 ********************************************************************PGR-GNU*/

#ifndef INCLUDE_CPP_COMMON_VRP_VROOM_PROBLEM_HPP_
#define INCLUDE_CPP_COMMON_VRP_VROOM_PROBLEM_HPP_
#pragma once

#include <string>
#include <vector>
#include <unordered_set>
#include <utility>

#include "c_types/vroom/vroom_job_t.h"
#include "c_types/vroom/vroom_rt.h"
#include "c_types/vroom/vroom_shipment_t.h"
#include "c_types/vroom/vroom_vehicle_t.h"
#include "c_types/matrix_cell_t.h"
#include "cpp_common/pgr_messages.h"
#include "cpp_common/base_matrix.h"

#include "structures/vroom/input/input.h"
#include "structures/vroom/job.h"
#include "structures/vroom/vehicle.h"

namespace vrprouting {

class Vrp_vroom_problem : public vrprouting::Pgr_messages {
 public:
  std::vector<vroom::Job> jobs() const { return m_jobs; }
  std::vector<std::pair<vroom::Job, vroom::Job>> shipments() const { return m_shipments; }
  std::vector<vroom::Vehicle> vehicles() const { return m_vehicles; }
  vrprouting::base::Base_Matrix matrix() const { return m_matrix; }

  /**
   * @name vroom time window wrapper
   */
  ///@{
  /**
   * @brief      Gets the vroom time window from the C-style struct
   *
   * @param[in]  time_window  The C-style time window struct
   *
   * @tparam     T            { Vroom_time_window_t }
   *
   * @return     The vroom time window.
   */
  template < typename T >
  vroom::TimeWindow
  get_vroom_time_window(const T &time_window) const {
    return
    vroom::TimeWindow(time_window.start_time,
                      time_window.end_time);
  }

  template < typename T >
  vroom::TimeWindow
  get_vroom_time_window(T start_time, T end_time) const {
    return
    vroom::TimeWindow(start_time, end_time);
  }

  template < typename T >
  std::vector < vroom::TimeWindow >
  get_vroom_time_windows(const std::vector < T > &time_windows) const {
    std::vector < vroom::TimeWindow > tws;
    for (auto time_window : time_windows) {
      tws.push_back(get_vroom_time_window(time_window));
    }
    if (tws.size()) {
      return tws;
    } else {
      return std::vector<vroom::TimeWindow>(1, vroom::TimeWindow());
    }
  }

  template < typename T >
  std::vector < vroom::TimeWindow >
  get_vroom_time_windows(const T *time_windows, size_t count) const {
    return
    get_vroom_time_windows(std::vector < T >(time_windows,
                                       time_windows + count));
  }
  ///@}

  /**
   * @name vroom breaks wrapper
   */
  ///@{
  /**
   * @brief      Gets the vehicle breaks from C-style breaks struct
   *
   * @param[in]  v_break  The vehicle break struct
   *
   * @tparam     T        { Vroom_break_t }
   *
   * @return     The vroom vehicle break.
   */
  template < typename T >
  vroom::Break
  get_vroom_break(const T &v_break) const {
    std::vector < vroom::TimeWindow > tws =
        get_vroom_time_windows(v_break.time_windows,
                         v_break.time_windows_size);
    return vroom::Break(v_break.id, tws, v_break.service);
  }

  template < typename T >
  std::vector < vroom::Break >
  get_vroom_breaks(const std::vector < T > &v_breaks) const {
    std::vector < vroom::Break > breaks;
    for (auto v_break : v_breaks) {
      breaks.push_back(get_vroom_break(v_break));
    }
    return breaks;
  }

  template < typename T >
  std::vector < vroom::Break >
  get_vroom_breaks(const T *breaks, size_t count) const {
    return
    get_vroom_breaks(std::vector < T >(breaks,
                                 breaks + count));
  }
  ///@}

  /**
   * @name vroom amounts wrapper
   */
  ///@{
  /**
   * @brief      Gets the vroom amounts from C-style array
   *
   * @param[in]  amounts  The amounts array (pickup or delivery)
   *
   * @tparam     T        { Amount }
   *
   * @return     The vroom amounts.
   */
  template < typename T >
  vroom::Amount
  get_vroom_amounts(const std::vector < T > &amounts) const {
    vroom::Amount amt;
    for (auto amount : amounts) {
      amt.push_back(amount);
    }
    return amt;
  }

  template < typename T >
  vroom::Amount
  get_vroom_amounts(const T *amounts, size_t count) const {
    return
    get_vroom_amounts(std::vector < T >(amounts,
                                  amounts + count));
  }
  ///@}

  /**
   * @name vroom skills wrapper
   */
  ///@{
  /**
   * @brief      Gets the vroom skills.
   *
   * @param[in]  skills  The skills array
   * @param[in]  count   The size of skills array
   *
   * @tparam     T       { Skill  or uint32_t }
   *
   * @return     The vroom skills.
   */
  template < typename T >
  vroom::Skills
  get_vroom_skills(const T *skills, size_t count) const {
    return std::unordered_set < T >(skills, skills + count);
  }
  ///@}


  /**
   * @name vroom jobs wrapper
   */
  ///@{
  /**
   * @brief      Gets the vroom jobs.
   *
   * @param[in]  job   The job C-style struct
   *
   * @tparam     T     { vroom_job_t }
   *
   * @return     The vroom job.
   */
  template < typename T >
  vroom::Job get_vroom_job(const T &job) const {
    vroom::Amount delivery =
        get_vroom_amounts(job.delivery, job.delivery_size);
    vroom::Amount pickup =
        get_vroom_amounts(job.pickup, job.pickup_size);
    vroom::Skills skills =
        get_vroom_skills(job.skills, job.skills_size);
    std::vector < vroom::TimeWindow > time_windows =
        get_vroom_time_windows(job.time_windows, job.time_windows_size);
    vroom::Index location_index =
        static_cast<vroom::Index>(m_matrix.get_index(job.location_index));
    return vroom::Job(job.id, location_index, job.service, delivery, pickup,
                      skills, job.priority, time_windows);
  }

  /**
   * @brief      Adds jobs to the problem instance
   *
   * @param[in]  job   The job
   *
   * @tparam     T     { vroom_job_t }
   */
  template < typename T >
  void problem_add_job(const T &job) {
    m_jobs.push_back(get_vroom_job(job));
  }

  template < typename T >
  void add_jobs(const std::vector < T > &jobs) {
    for (auto job : jobs) {
      problem_add_job(job);
    }
  }

  template < typename T >
  void add_jobs(const T *jobs, size_t count) {
    add_jobs(std::vector < T >(jobs, jobs + count));
  }
  ///@}

  template < typename T >
  std::pair<vroom::Job, vroom::Job>
  get_vroom_shipment(const T &shipment) const {
    vroom::Amount amount =
        get_vroom_amounts(shipment.amount, shipment.amount_size);
    vroom::Skills skills =
        get_vroom_skills(shipment.skills, shipment.skills_size);
    std::vector < vroom::TimeWindow > p_time_windows =
        get_vroom_time_windows(shipment.p_time_windows,
                               shipment.p_time_windows_size);
    std::vector < vroom::TimeWindow > d_time_windows =
        get_vroom_time_windows(shipment.d_time_windows,
                               shipment.d_time_windows_size);
    vroom::Index p_location_index = static_cast<vroom::Index>(
        m_matrix.get_index(shipment.p_location_index));
    vroom::Index d_location_index = static_cast<vroom::Index>(
        m_matrix.get_index(shipment.d_location_index));
    vroom::Job pickup = vroom::Job(shipment.p_id, vroom::JOB_TYPE::PICKUP,
                                   p_location_index, shipment.p_service, amount,
                                   skills, shipment.priority, p_time_windows);
    vroom::Job delivery = vroom::Job(
        shipment.d_id, vroom::JOB_TYPE::DELIVERY, d_location_index,
        shipment.d_service, amount, skills, shipment.priority, d_time_windows);
    return std::make_pair(pickup, delivery);
  }

  template < typename T >
  void problem_add_shipment(const T &shipment) {
    m_shipments.push_back(get_vroom_shipment(shipment));
  }

  template < typename T >
  void add_shipments(const std::vector < T > &shipments) {
    for (auto shipment : shipments) {
      problem_add_shipment(shipment);
    }
  }

  template < typename T >
  void add_shipments(const T *shipments, size_t count) {
    add_shipments(std::vector < T >(shipments, shipments + count));
  }

  template < typename T >
  vroom::Vehicle get_vroom_vehicle(const T &vehicle) const {
    vroom::Amount capacity =
        get_vroom_amounts(vehicle.capacity, vehicle.capacity_size);
    vroom::Skills skills =
        get_vroom_skills(vehicle.skills, vehicle.skills_size);
    vroom::TimeWindow time_window =
        get_vroom_time_window(vehicle.time_window_start,
                              vehicle.time_window_end);
    std::vector < vroom::Break > breaks =
        get_vroom_breaks(vehicle.breaks, vehicle.breaks_size);

    vroom::Index start_index =
        static_cast<vroom::Index>(m_matrix.get_index(vehicle.start_index));
    vroom::Index end_index =
        static_cast<vroom::Index>(m_matrix.get_index(vehicle.end_index));
    return vroom::Vehicle(vehicle.id, start_index, end_index,
                          vroom::DEFAULT_PROFILE, capacity, skills, time_window,
                          breaks, "", vehicle.speed_factor);
  }

  template < typename T >
  void problem_add_vehicle(const T &vehicle) {
    m_vehicles.push_back(get_vroom_vehicle(vehicle));
  }

  template < typename T >
  void add_vehicles(const std::vector < T > &vehicles) {
    for (auto vehicle : vehicles) {
      problem_add_vehicle(vehicle);
    }
  }

  template < typename T >
  void add_vehicles(const T *vehicles, size_t count) {
    add_vehicles(std::vector < T >(vehicles, vehicles + count));
  }

  // template <typename T>
  void add_matrix(vrprouting::base::Base_Matrix time_matrix) {
    m_matrix = time_matrix;
  }

  void get_amount(vroom::Amount vroom_amount, Amount **amount) {
    size_t amount_size = vroom_amount.size();
    for (size_t i = 0; i < amount_size; i++) {
      *((*amount) + i) = vroom_amount[i];
    }
  }

  std::vector < Vroom_rt > get_results(vroom::Solution solution) {
    std::vector < Vroom_rt > results;
    std::vector<vroom::Route> routes = solution.routes;
    Idx vehicle_seq = 1;
    for (auto route : routes) {
      Idx step_seq = 1;
      for (auto step : route.steps) {
        int32_t step_type = 0;
        Idx task_id = step.id;
        switch (step.step_type) {
          case vroom::STEP_TYPE::START:
            step_type = 1;
            task_id = -1;
            break;
          case vroom::STEP_TYPE::END:
            step_type = 6;
            task_id = -1;
            break;
          case vroom::STEP_TYPE::BREAK:
            step_type = 5;
            task_id = -1;
            break;
          case vroom::STEP_TYPE::JOB:
            switch (step.job_type) {
              case vroom::JOB_TYPE::SINGLE:
                step_type = 2;
                break;
              case vroom::JOB_TYPE::PICKUP:
                step_type = 3;
                break;
              case vroom::JOB_TYPE::DELIVERY:
                step_type = 4;
                break;
            }
            break;
        }
        size_t load_size = step.load.size();
        Amount *load = reinterpret_cast<Amount*>(malloc(load_size * sizeof(Amount)));
        get_amount(step.load, &load);

        results.push_back({
          vehicle_seq,        // vehicles_seq
          route.vehicle,      // vehicles_id
          step_seq,           // step_seq
          step_type,          // step_type
          task_id,            // task_id
          step.arrival,       // arrival
          step.duration,      // duration
          step.service,       // service_time
          step.waiting_time,  // waiting_time
          load,               // load
          load_size           // load size
        });
        step_seq++;
      }
      vehicle_seq++;
    }
    return results;
  }

  std::vector < Vroom_rt > solve() {
    std::vector <Vroom_rt> results;
    try {
      const unsigned int amount_size =
          m_vehicles.size()
              ? static_cast<unsigned int>(m_vehicles[0].capacity.size())
              : 0;
      vroom::Input problem_instance(amount_size);

      for (const auto &vehicle : m_vehicles) {
        problem_instance.add_vehicle(vehicle);
      }
      for (const auto &job : m_jobs) {
        problem_instance.add_job(job);
      }
      for (const auto &shipment : m_shipments) {
        problem_instance.add_shipment(shipment.first, shipment.second);
      }
      vroom::Matrix<vroom::Cost> matrix = m_matrix.get_vroom_matrix();
      problem_instance.set_matrix(vroom::DEFAULT_PROFILE, std::move(matrix));

      auto solution = problem_instance.solve(5, 4);
      results = get_results(solution);
    } catch (const vroom::Exception &ex) {
      throw;
    } catch (const std::exception &ex) {
      throw;
    } catch (...) {
      throw;
    }
    return results;
  }

 private:
  std::vector<vroom::Job> m_jobs;
  std::vector<std::pair<vroom::Job, vroom::Job>> m_shipments;
  std::vector<vroom::Vehicle> m_vehicles;
  vrprouting::base::Base_Matrix m_matrix;
};

}  // namespace vrprouting

#endif  // INCLUDE_CPP_COMMON_VRP_VROOM_PROBLEM_HPP_
